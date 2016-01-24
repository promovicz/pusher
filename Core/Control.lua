--
-- Representation of physical "controls"
--
-- Every button, knob, pad or whatever on the physical Push is
-- represented and controlled by some variant of this class.
--
-- Subclasses can register for specific MIDI commands and
-- dispatch corresponding events to the activity system.
--
-- Instances also have to manage any output that needs
-- to be done for a control. For that purpose there is
-- an invalidation mechanism for update compression.
--

class 'PusherControl'

-- Main initializer
function PusherControl:__init(type, id)
   self.type = type
   self.id = id
   self.pusher = nil
   self.invalid = true
end

-- Called when a control is registered
function PusherControl:register(pusher)
   self.pusher = pusher
end

-- Returns the current handler for this control
function PusherControl:get_handler()
   return self.pusher:get_control_handler(self.id)
end

-- Called to request sending an update
function PusherControl:invalidate()
   self.invalid = true
end

-- Called to send updates if required
function PusherControl:update()
   self.invalid = false
end

-- Logging helpers
function PusherControl:log_i(...)
   --print(self.type, self.id, ...)
end
function PusherControl:log_o(...)
   --print(self.type, self.id, ...)
end

-- Dummy MIDI event handlers
function PusherControl:on_cc(control,value)
end
function PusherControl:on_note_on(note,value)
end
function PusherControl:on_note_off(note,value)
end
function PusherControl:on_note_aftertouch(note,value)
end
function PusherControl:on_bend(value)
end
