
class 'DeviceDialog' (DisplayActivity)

function DeviceDialog:__init()
   DisplayActivity.__init(self, 'device')
end

function DeviceDialog:register(pusher)
   LOG("DeviceDialog: register()")
   DisplayActivity.register(self, pusher)

   self.display_name = {
      self:get_widget('display-1-1'),
      self:get_widget('display-2-1'),
      self:get_widget('display-3-1'),
      self:get_widget('display-4-1')
   }
   self.display_graph = {
      self:get_widget('display-1-2'),
      self:get_widget('display-2-2'),
      self:get_widget('display-3-2'),
      self:get_widget('display-4-2')
   }
end

function DeviceDialog:on_button_press(control)
   local id = control.id
end

function DeviceDialog:update()
   LOG("DeviceDialog: update()")
end
