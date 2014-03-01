
class 'Pusher'

function Pusher:__init(port_in, port_out)
   -- create midi interface
   self.midi = PusherMidi(port_in, port_out)
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
  -- open MIDI ports
  self.midi:open()
  -- initialize the controller
  self:initialize_device()
end

function Pusher:release()
  LOG("Pusher: release()")
  -- close MIDI ports
  self.midi:close()
end

-- delegations to MIDI interface
function Pusher:register_cc(cc, control)
   self.midi:register_cc(cc, control)
end
function Pusher:register_note(key, control)
   self.midi:register_note(key, control)
end
function Pusher:send_sysex(...)
   self.midi:send_sysex(...)
end
function Pusher:send_cc(number, value, channel)
   self.midi:send_cc(number, value, channel)
end
function Pusher:send_note(key, velocity, channel)
   self.midi:send_note(key, velocity, channel)
end

-- adds a control
function Pusher:add_control(control)
   if (control.group == nil) then
      control.group = 'none'
   end

   LOG("control", control.id, "in group", control.group)

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

-- get pad counting from bottom left
function Pusher:get_pad_bottom(x, y)
   if (x >= 1 and x <= 8 and y >= 1 and y <= 8) then
      return self.pads[y][x]
   else
      return nil
   end
end

-- get pad counting from top left
function Pusher:get_pad_top(x, y)
   if (x >= 1 and x <= 8 and y >= 1 and y <= 8) then
      return self.pads[8 - (y - 1)][x]
   else
      return nil
   end
end

-- get the pad control for the given coordinates
function Pusher:get_pad(x, y)
   return self.controls['pad-' .. x .. '-' .. y]
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
     c.group = b.group
     self:add_control(c)
  end
  -- dials
  for _, def in pairs(DIALS) do
     local dial = PusherDial(def.id, def.cc, def.note)
     dial.group = def.group
     self:add_control(dial)
  end
  -- display
  for index in range(1, 4) do
     local display =
        PusherDisplay("display-" .. index,
                      index,
                      DISPLAY_CLEAR[index],
                      DISPLAY_WRITE[index])
     display.group = "display"
     self:add_control(display)
  end
  -- pads
  local pads = { }
  for y in range(0, 7) do
     local padline = { }
     local palette = PALETTES['rgb']
     for x in range(0, 7) do
        local id = ("pad-%d-%d"):format(x + 1, y + 1)
        local p = PusherPad(id, x + 1, y + 1, 36 + x + (y * 8), palette)
        p.group = 'pads'
        self:add_control(p)
        padline[x + 1] = p
     end
     pads[y + 1] = padline
  end
  self.pads = pads
end

-- initialize all activities
function Pusher:initialize_activities()
   LOG("Pusher: initialize_activities()")
   -- create activities
   local root = RootActivity()
   root:register(self)
   local transport = TransportActivity()
   transport:register(self)
   local m = NotesActivity()
   m:register(self)
   -- set up a static activity stack
   self.activity_stack = {m, transport, root}
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
