
class 'PusherDial' (PusherControl)

function PusherDial:__init(id, cc, note)
   PusherControl.__init(self, 'dial', id)
   self.cc = cc
   self.note = note
end

function PusherDial:register(pusher)
   PusherControl.register(self, pusher)
   pusher:register_cc(self.cc, self)
   pusher:register_note(self.note, self)
end

function PusherDial:on_cc(control, value)
   local change
   if (value > 64) then
      change = 0 - (128 - value)
   else
      change = value
   end
   self:do_change(change)
end

function PusherDial:on_note_on(note, value)
   if (value == 127) then
      self:do_touch()
   else
      self:do_release()
   end
end

function PusherDial:do_touch()
   LOG("dial touched", self.id)
   local handler = self:get_handler()
   if (handler ~= nil) then
      handler:on_dial_touch(self)
   end
end

function PusherDial:do_release()
   LOG("dial released", self.id)
   local handler = self:get_handler()
   if (handler ~= nil) then
      handler:on_dial_release(self)
   end
end

function PusherDial:do_change(change)
   LOG("dial changed", self.id, change)
   local handler = self:get_handler()
   if (handler ~= nil) then
      handler:on_dial_change(self, change)
   end
end
