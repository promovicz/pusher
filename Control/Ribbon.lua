--
-- Representation of the touch ribbon
--

class 'PusherRibbon' (PusherControl)

function PusherRibbon:__init(id, note)
   PusherControl.__init(self, 'ribbon', id)
   self.touched = false
   self.note = note
end

function PusherRibbon:register(pusher)
   PusherControl.register(self, pusher)
   pusher:register_note(self.note, self)
   pusher:register_bend(self)
end

function PusherRibbon:invalidate()
   PusherControl.invalidate(self)
   self.touched = false
end

function PusherRibbon:update()
   if (self.invalid) then
      self.invalid = false
   end
end

function PusherRibbon:on_note_on(note, value)
   if (value == 127) then
      self:do_touch()
   else
      self:do_release()
   end
end

function PusherRibbon:on_bend(value)
   self:log_i("ribbon", self.id, "bend", value)
   local handler = self:get_handler()
   if (handler ~= nil and self.widget ~= nil) then
      handler:on_ribbon_bend(self.widget, value)
   end
end

function PusherRibbon:do_touch()
   self:log_i("ribbon", self.id, "touched")
   self.touched = true
   local handler = self:get_handler()
   if (handler ~= nil and self.widget ~= nil) then
      handler:on_ribbon_touch(self.widget)
   end
end

function PusherRibbon:do_release()
   self:log_i("ribbon", self.id, "released")
   self.touched = false
   local handler = self:get_handler()
   if (handler ~= nil and self.widget ~= nil) then
      handler:on_ribbon_release(self.widget)
   end
end
