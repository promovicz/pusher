
class 'DisplayActivity' (PusherActivity)

function DisplayActivity:__init(type)
   PusherActivity.__init(self, type)
end

function DisplayActivity:register(pusher)
   PusherActivity.register(self, pusher)

   self:handle_control_group('display')
   self:handle_control_group('knobs')
   self:handle_control_group('page')
   self:handle_control_group('track-select')
   self:handle_control_group('track-state')

   self.parameters = nil

   self.page_left = self:get_widget("back")
   self.page_right = self:get_widget("forward")

   self.knobs = {
      self:get_widget('knob-1'),
      self:get_widget('knob-2'),
      self:get_widget('knob-3'),
      self:get_widget('knob-4'),
      self:get_widget('knob-5'),
      self:get_widget('knob-6'),
      self:get_widget('knob-7'),
      self:get_widget('knob-8')
   }
   self.touched = {
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
   }
   self.line_a = {
      self:get_widget('display-1-1'),
      self:get_widget('display-2-1'),
      self:get_widget('display-3-1'),
      self:get_widget('display-4-1')
   }
   self.line_b = {
      self:get_widget('display-1-2'),
      self:get_widget('display-2-2'),
      self:get_widget('display-3-2'),
      self:get_widget('display-4-2')
   }
   self.line_c = {
      self:get_widget('display-1-3'),
      self:get_widget('display-2-3'),
      self:get_widget('display-3-3'),
      self:get_widget('display-4-3')
   }
   self.line_d = {
      self:get_widget('display-1-4'),
      self:get_widget('display-2-4'),
      self:get_widget('display-3-4'),
      self:get_widget('display-4-4')
   }

   self.parameter_name = nil
   self.parameter_value = nil
end

function DisplayActivity:on_dial_touch(control)
   if (control.group == 'knobs') then
      self.touched[control.x] = true
      self:update_parameters()
   end
end

function DisplayActivity:on_dial_release(control)
   if (control.group == 'knobs') then
      self.touched[control.x] = false
      self:update_parameters()
   end
end

function DisplayActivity:on_dial_change(control, change)
   if (control.group == 'knobs') then
      if self.parameters ~= nil then
         local parameter = self.parameters[control.x]
         if parameter ~= nil then
            self:adjust_parameter(parameter, change)
            self:update_parameters()
         end
      end
   end
end

function DisplayActivity:adjust_parameter(parameter,change)
   if (parameter ~= nil) then
      local quantum = parameter.value_quantum
      if (quantum == 0) then
         local range = parameter.value_max + math.abs(parameter.value_min)
         quantum = range / 250.0
      end
      local difference = change * quantum
      local new = parameter.value + difference
      new = math.min(parameter.value_max, new)
      new = math.max(parameter.value_min, new)
      parameter.value = new
   end
end

function DisplayActivity:update_parameters()
   if (self.parameters ~= nil) then
      self:display_parameters(
         self.parameters,
         self.touched,
         self.parameter_name,
         self.parameter_value
      )
   end
end

function DisplayActivity:display_parameters(parameters,touched,first,second)
   for i in range(0,3) do
      local pa = parameters[i*2+1]
      local pb = parameters[i*2+2]
      local ta = touched[i*2+1]
      local tb = touched[i*2+2]
      local first = first[i+1]
      local second = second[i+1]
      local firsta = self:display_parameter_name(pa)
      local firstb = self:display_parameter_name(pb)
      local seconda = self:display_parameter_value(pa)
      local secondb = self:display_parameter_value(pb)
      if ta then
         firsta = self:display_parameter_graph(pa)
      end
      if tb then
         firstb = self:display_parameter_graph(pb)
      end
      first:set_split(firsta, firstb)
      second:set_split(seconda, secondb)
   end
end
function DisplayActivity:display_parameter_name(parameter)
   if (parameter ~= nil) then
      return parameter.name
   else
      return ""
   end
end
function DisplayActivity:display_parameter_value(parameter)
   if (parameter ~= nil) then
      return parameter.value_string
   else
      return ""
   end
end
function DisplayActivity:display_parameter_graph(parameter)
   local width = 8
   if (parameter ~= nil) then
      if (parameter.polarity == renoise.DeviceParameter.POLARITY_UNIPOLAR) then
         local value = parameter.value + math.abs(parameter.value_min)
         local range = parameter.value_max + math.abs(parameter.value_min)
         local step = range / (width + 1)
         local steps = math.max(0, math.min(width, math.floor(value / step)))
         local limlo = ""
         local limhi = ""
         local space = width - steps
         if (parameter.value == parameter.value_min) then
            limlo = "0"
            space = space - 1
         end
         if (parameter.value == parameter.value_max) then
            limhi = "!"
            steps = steps - 1
         end
         return limlo .. PIPES[steps + 1] .. limhi .. DASHES[space + 1]
      elseif (parameter.polarity == renoise.DeviceParameter.POLARITY_BIPOLAR) then
         return ""
      end
   else
      return ""
   end
end
