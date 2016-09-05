--
-- Representation of the touch ribbon
--

class 'PusherRibbon' (PusherControl)

function PusherRibbon:__init(id, note)
   PusherControl.__init(self, 'ribbon', id)
   self.note = note
   self.touched = false
   self.bend = 0
   self.mode = 'pitchbend'
   self.leds = {
      false,false,false,false,
      false,false,false,false,
      false,false,false,false,
      false,false,false,false,
      false,false,false,false,
      false,false,false,false,
   }
   self.last_mode = nil
   self.last_leds = nil
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
   local send_leds = false
   if (self.invalid or self.mode ~= self.last_mode) then
      local mode = self.mode
      local mobj = RIBBON_MODES[self.mode]
      if mode == 'custom-free' then
         send_leds = true
      end
      self.pusher:send_sysex(
         SYSEX_START, RIBBON_SET_MODE, {mobj.value}
      )
      self.last_mode = mode
   end
   if send_leds then
      if (self.invalid or self.leds ~= self.last_leds) then
         local leds = self.leds
         local bytes = {1, 2, 3}
         self.pusher:send_sysex(
            SYSEX_START, RIBBON_SET_LEDS, bytes
         )
         self.last_leds = leds
      end
   else
      self.last_leds = nil
   end
   self.invalid = false
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
   self.bend = value
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
