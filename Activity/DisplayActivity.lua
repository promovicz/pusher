
class 'DisplayActivity' (PusherActivity)

function DisplayActivity:__init(type)
   PusherActivity.__init(self, type)
end

function DisplayActivity:register(pusher)
   PusherActivity.register(self, pusher)

   self:handle_control_group('display')
   self:handle_control_group('knobs')
   self:handle_control_group('track-select')
   self:handle_control_group('track-state')

   self.line_a = {
      self:get_control('display-1-1'),
      self:get_control('display-2-1'),
      self:get_control('display-3-1'),
      self:get_control('display-4-1')
   }
   self.line_b = {
      self:get_control('display-1-2'),
      self:get_control('display-2-2'),
      self:get_control('display-3-2'),
      self:get_control('display-4-2')
   }
   self.line_c = {
      self:get_control('display-1-3'),
      self:get_control('display-2-3'),
      self:get_control('display-3-3'),
      self:get_control('display-4-3')
   }
   self.line_d = {
      self:get_control('display-1-4'),
      self:get_control('display-2-4'),
      self:get_control('display-3-4'),
      self:get_control('display-4-4')
   }
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
   self:display_parameters(
      self.parameters,
      self.parameter_name,
      self.parameter_graph,
      self.parameter_value
   )
end

function DisplayActivity:display_parameters(parameters,names,graphs,values)
   for i in range(0,3) do
      local a = parameters[i*2+1]
      local b = parameters[i*2+2]
      if (names ~= nil) then
         names[i+1]:set_split(self:display_parameter_name(a),
                              self:display_parameter_name(b))
      end
      if (graphs ~= nil) then
         graphs[i+1]:set_split(self:display_parameter_graph(a),
                               self:display_parameter_graph(b))
      end
      if (values ~= nil) then
         values[i+1]:set_split(self:display_parameter_value(a),
                               self:display_parameter_value(b))
      end
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
      local value = parameter.value + math.abs(parameter.value_min)
      local range = parameter.value_max + math.abs(parameter.value_min)
      local step = range / (width + 1)
      if (parameter.polarity == renoise.DeviceParameter.POLARITY_UNIPOLAR) then
         local steps = math.min(width, math.floor(value / step))
         local limlo = ""
         local limhi = ""
         local space = width - steps
         if (value == parameter.value_min) then
            limlo = "0"
            space = space - 1
         end
         if (value == parameter.value_max) then
            limhi = "!"
            steps = steps - 1
         end
         return limlo .. PIPES[steps + 1] .. limhi .. DASHES[space + 1]
      else
         return "--------"
      end
   else
      return ""
   end
end
