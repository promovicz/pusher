--
--
--

class 'PatternActivity' (PusherActivity)

function PatternActivity:__init()
   PusherActivity.__init(self, 'pattern')
end

function PatternActivity:register()
   PusherActivity.register(self)

   local pads = self:handle_control_group('pads')
end
