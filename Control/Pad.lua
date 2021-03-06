--
-- Representation of attack-sensitive aftertouching pads
--

class 'PusherPad' (PusherControl)

function PusherPad:__init(id, x, y, note, palette)
   PusherControl.__init(self, 'pad', id)
   self.x = x
   self.y = y
   self.note = note
   self.palette = palette
   self.color = 'off'
   self.last_color = 'off'
end

function PusherPad:register(pusher)
   PusherControl.register(self, pusher)
   pusher:register_note(self.note, self)
end

function PusherPad:update()
   local color = self.color
   if (self.invalid or (self.last_color ~= color)) then
      self:log_o("color", color)
      self.pusher:send_note(self.note, self.palette[color].value)
      self.last_color = color
      self.invalid = false
   end
end

function PusherPad:set_color(color)
   if (color == nil) then
      color = 'off'
   end
   self.color = color
   self:update()
end

function PusherPad:on_note_on(note, value)
   if (value > 0) then
      self:do_press(value)
   else
      self:do_release()
   end
end

function PusherPad:on_note_off(note, value)
   self:do_release()
end

function PusherPad:on_note_aftertouch(note, value)
   self:do_aftertouch(value)
end

function PusherPad:do_press(value)
   self:log_i("pressed", value)
   local handler = self:get_handler()
   if (handler ~= nil and self.widget ~= nil) then
      handler:on_pad_press(self.widget, value)
   end
end

function PusherPad:do_release()
   self:log_i("released")
   local handler = self:get_handler()
   if (handler ~= nil and self.widget ~= nil) then
      handler:on_pad_release(self.widget)
   end
end

function PusherPad:do_aftertouch(value)
   self:log_i("aftertouch", value)
   local handler = self:get_handler()
   if (handler ~= nil and self.widget ~= nil) then
      handler:on_pad_aftertouch(self.widget, value)
   end
end
