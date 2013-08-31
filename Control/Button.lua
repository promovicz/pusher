
class 'PusherButton' (PusherControl)

function PusherButton:__init(id, cc, palette)
   PusherControl.__init(self, 'button', id)
   self.cc = cc
   self.palette = palette
   self.color = 'off'
   self.last_color = 'off'
end

function PusherButton:register(pusher)
   PusherControl.register(self, pusher)
   pusher:register_cc(self.cc, self)
end

function PusherButton:update()
   local color = self.color
   if (self.invalid or (self.last_color ~= color)) then
      local defn = self.palette[color]
      -- LOG("button", self.id, "color", color, "really", defn.name)
      self.pusher:send_cc(self.cc, defn.value)
      self.last_color = color
      self.invalid = false
   end
end

function PusherButton:set_color(color)
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
   LOG("button pressed", self.id)
   local handler = self:get_handler()
   if (handler ~= nil) then
      handler:on_button_press(self)
   end
end

function PusherButton:do_release()
   LOG("button released", self.id)
   local handler = self:get_handler()
   if (handler ~= nil) then
      handler:on_button_release(self)
   end
end
