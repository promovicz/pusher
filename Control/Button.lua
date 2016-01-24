--
-- Representation of regular pushbuttons
--

class 'PusherButton' (PusherControl)

function PusherButton:__init(id, cc, palette)
   PusherControl.__init(self, 'button', id)
   self.cc = cc
   self.palette = palette
   self.color = 'off'
   self.last_color = 'off'
   self.pressed = false
end

function PusherButton:register(pusher)
   PusherControl.register(self, pusher)
   pusher:register_cc(self.cc, self)
end

function PusherButton:invalidate()
   PusherControl.invalidate(self)
   self.pressed = false
end

function PusherButton:update()
   local color = self.color
   if (self.invalid or (self.last_color ~= color)) then
      local defn = self.palette[color]
      self:log_o("color", color)
      self.pusher:send_cc(self.cc, defn.value)
      self.last_color = color
      self.invalid = false
   end
end

function PusherButton:set_color(color)
   if (color == nil) then
      color = 'off'
   end
   self.color = color
   self:update()
end

function PusherButton:on_cc(control, value)
   if (value == 127) then
      self:do_press()
   else
      self:do_release()
   end
end

function PusherButton:do_press()
   self:log_i("pressed")
   self.pressed = true
   local handler = self:get_handler()
   if (handler ~= nil and self.widget ~= nil) then
      handler:on_button_press(self.widget)
   end
end

function PusherButton:do_release()
   self:log_i("released")
   self.pressed = false
   local handler = self:get_handler()
   if (handler ~= nil and self.widget ~= nil) then
      handler:on_button_release(self.widget)
   end
end
