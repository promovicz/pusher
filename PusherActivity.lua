
class 'PusherActivity'

function PusherActivity:__init(id)
   self.id = id
   self.controls = {}
   self.states = {}
   self.pusher = nil
end

function PusherActivity:register(pusher)
   self.pusher = pusher
end

function PusherActivity:handle_all_controls()
   LOG("activity", self.id, "handles all controls")
   self.controls = self.pusher.controls
end

function PusherActivity:handle_control(id)
   local control = self.pusher:get_control(id)
   LOG("activity", self.id, "handles control", control.id)
   self.controls[id] = control
   self.states[id] = { }
   return control
end

function PusherActivity:handle_control_group(group_id)
   LOG("activity", self.id, "handles group", group_id)
   local controls = self.pusher:get_control_group(group_id)
   for _, control in pairs(controls) do
      self.controls[control.id] = control
      self.states[control.id] = { }
   end
   return controls
end

function PusherActivity:set_color(id, color)
   self.states[id].color = color
end

function PusherActivity:set_text(id, text)
   self.states[id].text = text
end

function PusherActivity:set_text_4(id, parts, justify)
   local chunks = self:format_parts(parts, 4, 17, justify)
   self:set_text(
      id,
      chunks[1] .. chunks[2] ..
      chunks[3] .. chunks[4]
   )
end

function PusherActivity:set_text_8(id, parts, justify)
   local chunks = self:format_parts(parts, 8, 8, justify)
   self:set_text(
      id,
      chunks[1] .. " " .. chunks[2] ..
      chunks[3] .. " " .. chunks[4] ..
      chunks[5] .. " " .. chunks[6] ..
      chunks[7] .. " " .. chunks[8]
   )
end

-- default event handlers
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
