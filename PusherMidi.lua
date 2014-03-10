--
-- Bidirectional MIDI interface
--
-- This class parses and generates MIDI events and
-- also handles opening and closing of MIDI ports.
--
-- It actually isn't specific to the Push.
--

class 'PusherMidi'

function PusherMidi:__init(port_in, port_out)
   -- debug flag
   self.dump_midi = false
   -- MIDI port names
   self.port_in = port_in
   self.port_out = port_out
   -- MIDI handler tables
   self.handlers_cc = {}
   self.handlers_note = {}
   -- MIDI channel
   self.default_midi_channel = 1
end

-- open MIDI ports
function PusherMidi:open()
  -- list available devices
  local input_devices = renoise.Midi.available_input_devices()
  local output_devices = renoise.Midi.available_output_devices()
  -- find input
  if table.find(input_devices, self.port_in) then
    self.midi_in = renoise.Midi.create_input_device(self.port_in,
      {self, PusherMidi.midi_callback}
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
end

-- close MIDI ports
function PusherMidi:close()
  -- close input
  if (self.midi_in ~= nil and self.midi_in.is_open) then
    self.midi_in:close()
  end
  -- close output
  if (self.midi_out ~= nil and self.midi_out.is_open) then
    self.midi_out:close()
  end
  -- drop references
  self.midi_in = nil
  self.midi_out = nil
end

-- register a control as a MIDI control handler
function PusherMidi:register_cc(cc, control)
   self.handlers_cc[cc] = control
end

-- register a control as a MIDI note handler
function PusherMidi:register_note(note, control)
   self.handlers_note[note] = control
end

-- callback for incoming midi events
function PusherMidi:midi_callback(message)
  if (message[1] >= 128) and (message[1] <= 159) then
     -- note
     local channel, note, value, handler
     note = message[2]
     value = message[3]
     handler = self.handlers_note[note]
     if (message[1]>143)then
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

function PusherMidi:send_cc(number,value,channel)
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

function PusherMidi:send_note(key,velocity,channel)

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

function PusherMidi:send_sysex(...)
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
