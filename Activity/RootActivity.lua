-- 
-- RootActivity - disable-all-controls base activity
-- 
-- Akin to an empty canvas, this activity sets all controls
-- to their default "off" states so that we have something
-- sane to fall back on.
--
-- It will also highlight buttons when they are pressed.
-- 

class "RootActivity" (PusherActivity)

function RootActivity:__init()
   PusherActivity.__init(self, 'root')
end

function RootActivity:register(pusher)
   LOG("RootActivity: register()")
   PusherActivity.register(self, pusher)
   self:handle_all_controls()
end

function RootActivity:update()
   LOG("RootActivity: update()")
   for _, control in pairs(self.controls) do
      if (control.type == 'button' or control.type == 'pad') then
         control:set_color('off')
      end
      if (control.type == 'display') then
         control:set_text(" ")
      end
   end
end

function RootActivity:on_button_press(control)
   control:set_color('on')
end

function RootActivity:on_button_release(control)
   control:set_color('off')
end

function RootActivity:on_pad_press(control)
   control:set_color('on')
end

function RootActivity:on_pad_release(control)
   control:set_color('off')
end
