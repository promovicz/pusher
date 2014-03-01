
class 'DeviceDialog' (PusherActivity)

function DeviceDialog:__init()
   PusherActivity.__init(self, 'device')
end

function DeviceDialog:register(pusher)
   LOG("DeviceDialog: register()")
   PusherActivity.register(self, pusher)

   self:handle_control('device')
   self:handle_control_group('display')
   self:handle_control_group('knobs')
   self:handle_control_group('track-select')

   self.display_name = {
      self:get_control('display-1-1'),
      self:get_control('display-2-1'),
      self:get_control('display-3-1'),
      self:get_control('display-4-1')
   }
   self.display_graph = {
      self:get_control('display-1-2'),
      self:get_control('display-2-2'),
      self:get_control('display-3-2'),
      self:get_control('display-4-2')
   }
end

function DeviceDialog:on_button_press(control)
   local id = control.id
end

function DeviceDialog:update()
   LOG("DeviceDialog: update()")
end
