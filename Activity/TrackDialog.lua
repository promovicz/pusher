
class 'TrackDialog' (DisplayActivity)

function TrackDialog:__init()
   DisplayActivity.__init(self, 'track')
   self.parameters = { }
end

function TrackDialog:register(pusher)
   LOG("TrackDialog: register()")
   DisplayActivity.register(self, pusher)

   self:handle_control('track')

   self.parameter_name  = self.line_a
   self.parameter_value = self.line_b

   self.upper1 = self:get_widget('display-1-3')
   self.upper2 = self:get_widget('display-2-3')
   self.upper3 = self:get_widget('display-3-3')
   self.upper4 = self:get_widget('display-4-3')
   self.lower1 = self:get_widget('display-1-4')
   self.lower2 = self:get_widget('display-2-4')
   self.lower3 = self:get_widget('display-3-4')
   self.lower4 = self:get_widget('display-4-4')

   local song = renoise.song()
   song.tracks_observable:add_notifier(self, TrackDialog.on_tracks_changed)
   song.selected_track_observable:add_notifier(self, TrackDialog.on_selected_track_changed)
end

function TrackDialog:on_button_press(control)
   if (control.id == 'track') then
   end
   if (control.id == 'back') then
   end
   if (control.id == 'forward') then
   end
   if (control.group == 'track-select') then
      renoise.song().selected_track_index = control.x
   end
end

function TrackDialog:on_tracks_changed()
   self:update()
end
function TrackDialog:on_selected_track_changed()
   self:update()
end

function TrackDialog:update()
   local song = renoise.song()
   local track = song.selected_track

   self.tracks = song.tracks

   self:get_widget('track'):set_color('full')

   self.upper1:set_text("Selected track:", 1)
   self.upper2:set_text(track.name, 0)
   self.upper3:set_text()
   self.upper4:set_text()

   local names = { }
   local colors = { }
   for i, t in pairs(song.tracks) do
      local name = t.name
      local color = 'amber'
      if (i == song.selected_track_index) then
         color = 'green'
      end
      names[#names+1] = name
      colors[#colors+1] = color
   end
   self.lower1:set_split(names[1], names[2])
   self.lower2:set_split(names[3], names[4])
   self.lower3:set_split(names[5], names[6])
   self.lower4:set_split(names[7], names[8])
   for i = 1,8,1 do
      self:get_widget('track-select-' .. i):set_color(colors[i])
   end

   local parameters = { }
   local touched = { false, false, false, false, false, false, false, false }
   if (track ~= nil) then
      parameters[1] = track.prefx_volume
      parameters[2] = track.prefx_panning
      parameters[3] = track.prefx_width
      parameters[4] = track.postfx_volume
      parameters[5] = track.postfx_panning
   end
   self.parameters = parameters
   self.touched = touched
   self:update_parameters()
end
