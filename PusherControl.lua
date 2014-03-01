--
-- Base class of all 'controls'
--
-- Every button, knob, pad or whatever on the Push is
-- represented and controlled by some variant of this class.
--

class 'PusherControl'

function PusherControl:__init(type, id)
   self.type = type
   self.id = id
   self.pusher = nil
   self.invalid = true
end

function PusherControl:register(pusher)
   self.pusher = pusher
end

function PusherControl:get_handler()
   return self.pusher:get_control_handler(self.id)
end

function PusherControl:invalidate()
   self.invalid = true
end

function PusherControl:update()
   self.invalid = false
end

-- default event handlers
function PusherControl:on_cc(control,value)
end
function PusherControl:on_note_on(note,value)
end
function PusherControl:on_note_off(note,value)
end
function PusherControl:on_note_aftertouch(note,value)
end
