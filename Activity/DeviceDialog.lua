
class 'DeviceDialog' (DisplayActivity)

function DeviceDialog:__init()
   DisplayActivity.__init(self, 'device')
end

function DeviceDialog:register(pusher)
   LOG("DeviceDialog: register()")
   DisplayActivity.register(self, pusher)

   self:handle_control('device')

   self.parameter_name  = self.line_a
   self.parameter_value = self.line_b

   self.device_name   = self.line_d

   self:handle_control_group('track-select')
   self:handle_control_group('track-state')

   self.track = nil
   self.devices = { }

   local song = renoise.song()
   song.selected_track_observable:add_notifier(self, DeviceDialog.update)
   song.selected_track_device_observable:add_notifier(self, DeviceDialog.update)
end

function DeviceDialog:on_button_press(control)
   if control.group == 'track-select' then
      if self.devices then
         local device = self.devices[control.x]
         if device then
            renoise.song().selected_track_device_index = control.x
         end
      end
   end
   if control.group == 'track-state' then
      if self.devices then
         local device = self.devices[control.x]
         if device then
            renoise.song().selected_track_device_index = control.x
         end
      end
   end
end

function DeviceDialog:update()
   LOG("DeviceDialog: update()")

   self:get_widget('device'):set_color('full')

   local song = renoise.song()

   local device = song.selected_track_device
   if device ~= nil then
      self.parameters = device.parameters
   else
      self.parameters = { }
   end

   local track = song.selected_track
   self.track = track
   if track ~= nil then
      self.devices = track.devices
   else
      self.devices = { }
   end

   self:update_parameters()

   local selected_device = song.selected_track_device_index
   for i in range(0,3) do
      local idxa = i*2+1
      local idxb = i*2+2
      local deva = self.devices[idxa]
      local devb = self.devices[idxb]
      local name = self.device_name[i+1]
      local sela = self:get_widget('track-select-' .. idxa)
      local selb = self:get_widget('track-select-' .. idxb)
      local staa = self:get_widget('track-state-' .. idxa)
      local stab = self:get_widget('track-state-' .. idxb)
      local stra = ""
      local strb = ""
      if deva then
         stra = deva.name
         if idxa == selected_device then
            sela:set_color('green')
         else
            sela:set_color('amber')
         end
      else
         sela:set_color('off')
      end
      if devb then
         strb = devb.name
         if idxb == selected_device then
            selb:set_color('green')
         else
            selb:set_color('amber')
         end
      else
         selb:set_color('off')
      end
      name:set_split(stra, strb)
   end
end
