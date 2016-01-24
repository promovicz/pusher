
class 'PusherActivity'

function PusherActivity:__init(id)
   self.id = id
   self.controls = {}
   self.widgets = {}
   self.pusher = nil
end

function PusherActivity:log(...)
   print("activity", self.id, ...)
end

function PusherActivity:register(pusher)
   self.pusher = pusher
end

function PusherActivity:activate()
   for index, widget in pairs(self.widgets) do
      widget:activate()
   end
end

function PusherActivity:redraw()
   for index, widget in pairs(self.widgets) do
      widget:update()
   end
end

function PusherActivity:get_widget(id)
   return self.widgets[id]
end

-- get pad counting from top left
function PusherActivity:get_pad_top(x, y)
   if (x >= 1 and x <= 8 and y >= 1 and y <= 8) then
      return self.widgets["pad-" .. x .. "-" .. 9 - y]
   else
      return nil
   end
end

-- get pad counting from bottom left
function PusherActivity:get_pad_bottom(x, y)
   if (x >= 1 and x <= 8 and y >= 1 and y <= 8) then
      return self.widgets["pad-" .. x .. "-" .. y]
   else
      return nil
   end
end

function PusherActivity:handle_all_controls()
   self:log("handles all controls")
   self.controls = self.pusher.controls
   self.widgets = { }
   for _, control in pairs(self.controls) do
      self.widgets[control.id] = PusherWidget(self, control)
   end
end

function PusherActivity:handle_control(id)
   local control = self.pusher:get_control(id)
   self:log("handles control", control.id)
   local widget = PusherWidget(self, control)
   self.controls[id] = control
   self.widgets[id] = widget
   return widget
end

function PusherActivity:handle_control_group(group_id)
   self:log("handles group", group_id)
   local controls = self.pusher:get_control_group(group_id)
   local widgets = { }
   for index, control in pairs(controls) do
      local widget = PusherWidget(self, control)
      self.controls[control.id] = control
      self.widgets[control.id] = widget
      widgets[index] = widget
   end
   return widgets
end

-- Dummy global event handlers
function PusherActivity:on_mode_change(activity)
end

-- Dummy activity event handlers
function PusherActivity:on_dialog_show()
   self:log("show")
end
function PusherActivity:on_dialog_hide()
   self:log("hide")
end

-- Dummy control event handlers
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
function PusherActivity:on_ribbon_touch(control)
end
function PusherActivity:on_ribbon_release(control)
end
function PusherActivity:on_ribbon_bend(control)
end
function PusherActivity:on_pad_press(control, value)
end
function PusherActivity:on_pad_release(control)
end
function PusherActivity:on_pad_aftertouch(control, value)
end
