
class 'PusherActivity'

function PusherActivity:__init(id)
   self.id = id
   self.controls = {}
   self.pusher = nil
end

function PusherActivity:register(pusher)
   self.pusher = pusher
end

function PusherActivity:handle_control(id)
   local control = self.pusher:get_control(id)
   LOG("activity", self.id, "handles control", control.id)
   self.controls[id] = control
   return control
end

function PusherActivity:handle_control_group(group_id)
   LOG("activity", self.id, "handles group", group_id)
   local controls = self.pusher:get_control_group(group_id)
   for _, control in pairs(controls) do
      self.controls[control.id] = control
   end
   return controls
end

function PusherActivity:on_button_press(control)
end

function PusherActivity:on_button_release(control)
end

function PusherActivity:on_dial_touch(control)
end

function PusherActivity:on_dial_release(control)
end

function PusherActivity:on_dial_change(control, change)
end

function PusherActivity:on_pad_press(control, value)
end

function PusherActivity:on_pad_release(control)
end

function PusherActivity:on_pad_aftertouch(control, value)
end
