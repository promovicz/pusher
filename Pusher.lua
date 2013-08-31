
class 'Pusher'

function Pusher:__init(port_in, port_out)
   -- MIDI port names
   self.port_in = port_in
   self.port_out = port_out
   -- dump MIDI messages?
   self.dump_midi = false
   -- MIDI handler tables
   self.handlers_cc = {}
   self.handlers_note = {}
   -- MIDI channel
   self.default_midi_channel = 1
   -- all controls
   self.controls = {}
   -- stack of activities
   self.activity_stack = {}
   -- OSC client for note triggering
   self.osc_client = OscClient("127.0.0.1", 8000)
   self.voices = OscVoiceMgr(self.osc_client)
   -- create controls and activities
   self:initialize_controls()
   self:initialize_activities()
   -- open MIDI links
   self:open()
end

function Pusher:open()
  LOG("Pusher: open()")
  -- list available devices
  local input_devices = renoise.Midi.available_input_devices()
  local output_devices = renoise.Midi.available_output_devices()
  -- find input
  if table.find(input_devices, self.port_in) then
    self.midi_in = renoise.Midi.create_input_device(self.port_in,
      {self, Pusher.midi_callback}
    )
  else
    LOG("Notice: Could not create MIDI input device ", self.port_in)
  end
  -- find output
  if table.find(output_devices, self.port_out) then
    self.midi_out = renoise.Midi.create_output_device(self.port_out)
  else
    LOG("Notice: Could not create MIDI output device ", self.port_out)
  end
  -- initialize the controller
  self:initialize_device()
end

function Pusher:release()
  LOG("Pusher: release()")
  -- close input
  if (self.midi_in and self.midi_in.is_open) then
    self.midi_in:close()
  end
  -- close output
  if (self.midi_out and self.midi_out.is_open) then
    self.midi_out:close()
  end
  -- drop references
  self.midi_in = nil
  self.midi_out = nil
end

function Pusher:add_control(control)
   if (control.group == nil) then
      control.group = 'none'
   end

   self.controls[control.id] = control
   control:register(self)
end

-- get the control with the given id
function Pusher:get_control(id)
   return self.controls[id]
end

-- get all controls with the given group id
function Pusher:get_control_group(group_id)
   local result = table.create()
   for _, control in pairs(self.controls) do
      if (control.group == group_id) then
         result:insert(control)
      end
   end
   return result
end

-- get the topmost handler for the control with the given id
function Pusher:get_control_handler(id)
   for _, activity in pairs(self.activity_stack) do
      local control = activity.controls[id]
      if (control ~= nil) then
         return activity
      end
   end
   return nil
end

-- get the pad control for the given coordinates
function Pusher:get_pad(x, y)
   return self.controls['pad-' .. x .. '-' .. y]
end

-- register a control as a MIDI control handler
function Pusher:register_cc(cc, control)
   self.handlers_cc[cc] = control
end

-- register a control as a MIDI note handler
function Pusher:register_note(note, control)
   self.handlers_note[note] = control
end

-- create and register all controls
function Pusher:initialize_controls()
  LOG("Pusher: initialize_controls()")
  -- buttons
  for _, b in pairs(BUTTONS) do
     local p = b.palette
     if (p == nil) then
        p = 'simple'
     end
     local c = PusherButton(b.id, b.cc, PALETTES[p])
     self:add_control(c)
  end
  -- dials
  for _, def in pairs(DIALS) do
     local dial = PusherDial(def.id, def.cc, def.note)
     self:add_control(dial)
  end
  -- display
  for index in range(1, 4) do
     local display =
        PusherDisplay("display-" .. index,
                      index,
                      DISPLAY_CLEAR[index],
                      DISPLAY_WRITE[index])
     self:add_control(display)
  end
  -- pads
  for y in range(0, 7) do
     for x in range(0, 7) do
        local pal = 'rgb'
        local id = ("pad-%d-%d"):format(x + 1, y + 1)
        local p = PusherPad(id, x + 1, y + 1, 36 + x + (y * 8), PALETTES[pal])
        p.group = 'pads'
        self:add_control(p)
     end
  end
end

-- initialize all activities
function Pusher:initialize_activities()
   LOG("Pusher: initialize_activities()")
   -- create activities
   local root = RootActivity()
   root:register(self)
   local transport = TransportActivity()
   transport:register(self)
   local notes = NotesActivity()
   notes:register(self)
   -- set up a static activity stack
   self.activity_stack = {notes, transport, root}
end

-- initialize the controller
function Pusher:initialize_device()
  LOG("Pusher: initialize_device()")
  -- switch device to live native mode
  self:send_sysex(SYSEX_START, SET_MODE_LIVE)
  -- update all controls
  for i, c in pairs(self.controls) do
     c:invalidate()
     c:update()
  end
end

-- callback for incoming midi events
function Pusher:midi_callback(message)
  if (message[1] >= 128) and (message[1] <= 159) then
     -- note
     local channel, note, value, handler
     note = message[2]
     value = message[3]
     handler = self.handlers_note[note]
     if(message[1]>143)then
        -- note on
        channel = message[1]-143
        if (self.dump_midi) then
           LOG(("Pusher: recv CH %X NOTE %X ON %X"):format(channel, note, value))
        end
        if (handler ~= nil) then
           handler:on_note_on(note, value)
        end
     else
        -- note off
        channel = message[1]-127
        if (self.dump_midi) then
           LOG(("Pusher: recv CH %X NOTE %X OFF %X"):format(channel, note, value))
        end
        if (handler ~= nil) then
           handler:on_note_off(note, value)
        end
     end
  elseif (message[1] >= 160) and (message[1] <= 175) then
     -- polyphonic aftertouch
     local channel, note, value, handler
     channel = message[1] - 159
     note = message[2]
     value = message[3]
     handler = self.handlers_note[note]
     if (self.dump_midi) then
        LOG(("Pusher: recv CH %X NOTE %X AFTERTOUCH %X"):format(channel, note, value))
     end
     if (handler ~= nil) then
        handler:on_note_aftertouch(note, value)
     end
  elseif (message[1]>=176) and (message[1]<=191) then
     -- control change
     local channel, control, value, handler
     channel = message[1]-175
     control = message[2]
     value = message[3]
     handler = self.handlers_cc[control]
     if (self.dump_midi) then
        LOG(("Pusher: recv CH %X CONTROL %X VALUE %X"):format(channel, control, value))
     end
     if (handler ~= nil) then
        handler:on_cc(control, value)
     end
  elseif (message[1]>=208) and (message[1]<=223) then
     -- channel pressure
     local channel, value
     channel = message[1]-207
     value = message[2]
     if (self.dump_midi) then
        LOG(("Pusher: recv CH %X PRESSURE %X"):format(channel, value))
     end
  elseif (message[1]>=224) and (message[1]<=239) then
     -- pitch bend
     local channel, value
     channel = message[1] - 223
     value = message[3] * 128 + message[2]
     if (self.dump_midi) then
        LOG(("Pusher: recv CH %X BEND %X"):format(channel, value))
     end
  else
     -- unsupported - ignored
  end
end

function Pusher:send_cc(number,value,channel)
  if not channel then
    channel = self.default_midi_channel
  end

  if(self.dump_midi) then
     LOG("Pusher: send_cc()",number,value,channel)
  end

  if (not self.midi_out or not self.midi_out.is_open) then
    return
  end

  local message = {0xAF+channel, math.floor(number), math.floor(value)}

  self.midi_out:send(message)
end

function Pusher:send_note(key,velocity,channel)

  if not channel then
    channel = self.default_midi_channel
  end

  if (not self.midi_out or not self.midi_out.is_open) then
    return
  end

  key = math.floor(key)
  velocity = math.floor(velocity)
  
  local message = {nil, key, velocity}
  
  -- some devices cannot cope with note-off messages 
  -- being note-on messages with zero velocity...
  if (velocity == 0) and not (self.allow_zero_velocity_note_on) then
    message[1] = 0x7F+channel -- note off
  else
    message[1] = 0x8F+channel -- note-on
  end
  
  if(self.dump_midi)then
     LOG(("Pusher: send MIDI %X %X %X"):format(
            message[1], message[2], message[3]))
  end

  self.midi_out:send(message) 
end

function Pusher:send_sysex(...)
  if(self.dump_midi) then
     LOG("Pusher: send_sysex(...)")
  end

  if (not self.midi_out or not self.midi_out.is_open) then
    return
  end

  local message = table.create()
  local message_str = "0xF0"

  message:insert(0xF0)
  for _, m in ipairs({...}) do
     if (type(m) == 'table') then
        for _, e in ipairs(m) do
           message:insert(e)
        end
     elseif (type(m) == 'string') then
        for o in range(1, #m) do
           message:insert(string.byte(m, o))
        end
     end
  end
  message:insert(0xF7)

  self.midi_out:send(message)
end


