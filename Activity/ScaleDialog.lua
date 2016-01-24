
class 'ScaleDialog' (DisplayActivity)

function ScaleDialog:__init()
   DisplayActivity.__init(self, 'scale')
end

function ScaleDialog:register(pusher)
   LOG("ScaleDialog: register()")
   DisplayActivity.register(self, pusher)

   self.notes = pusher.a_notes

   self.track_select = self:handle_control_group('track-select')
   self.track_state  = self:handle_control_group('track-state')

   -- Prev C  G  D  A  E  B  Fixed
   -- Next F  Bb Eb Ab Db Gb Chromatic

   local t = { }
   t['track-select-2'] = 1
   t['track-select-3'] = 8
   t['track-select-4'] = 3
   t['track-select-5'] = 10
   t['track-select-6'] = 5
   t['track-select-7'] = 12
   t['track-state-2'] = 6
   t['track-state-3'] = 11
   t['track-state-4'] = 4
   t['track-state-5'] = 9
   t['track-state-6'] = 2
   t['track-state-7'] = 7
   self.button_keys = t
end

function ScaleDialog:prev_scale()
   self.notes:set_scale(math.max(SCALE_MIN, self.notes.scale - 1))
end

function ScaleDialog:next_scale()
   self.notes:set_scale(math.min(SCALE_MAX, self.notes.scale + 1))
end

function ScaleDialog:toggle_fixed()
   self.notes:set_fixed(not self.notes.fixed)
end

function ScaleDialog:toggle_chromatic()
   self.notes:set_chromatic(not self.notes.chromatic)
end

function ScaleDialog:on_button_press(control)
   local id = control.id
   if (id == 'scales') then
      self.pusher:hide_dialog(self)
   end
   if (self.button_keys[id] ~= nil) then
      self.notes:set_key(self.button_keys[id])
   end
   if (id == 'track-select-1') then
      self:prev_scale()
   end
   if (id == 'track-state-1') then
      self:next_scale()
   end
   if (id == 'track-select-8') then
      self:toggle_fixed()
   end
   if (id == 'track-state-8') then
      self:toggle_chromatic()
   end
   -- XXX need observer for scale manipulation
   self:update()
end

function ScaleDialog:update()
   LOG("ScaleDialog: update()")
   local keys = KEYS_COMBINED

   local button_prev = self:get_widget("track-select-1")
   local button_next = self:get_widget("track-state-1")
   local button_fixed = self:get_widget("track-select-8")
   local button_chromatic = self:get_widget("track-state-8")

   local scale_index = self.notes.scale
   local scale = SCALES[scale_index]
   local key = self.notes.key

   for _, c in pairs(self.track_select) do
      if (self.button_keys[c.id] ~= nil) then
         if (self.button_keys[c.id] == key) then
            c:set_color('green')
         else
            c:set_color('amber')
         end
      end
   end
   for _, c in pairs(self.track_state) do
      if (self.button_keys[c.id] ~= nil) then
         if (self.button_keys[c.id] == key) then
            c:set_color('green')
         else
            c:set_color('amber')
         end
      end
   end

   if (scale_index > SCALE_MIN) then
      button_prev:set_color('green')
   else
      button_prev:set_color('off')
   end
   if (scale_index < SCALE_MAX) then
      button_next:set_color('green')
   else
      button_next:set_color('off')
   end

   local mode
   local action_chromatic
   local action_fixed
   button_chromatic:set_color('green')
   if (self.notes.chromatic) then
      mode = "Chromatic"
      action_chromatic = "In Key"
      if (self.notes.fixed) then
         mode = "Fixed"
         action_fixed = "Variable"
      else
         action_fixed = "Fixed"
      end
      button_fixed:set_color('green')
   else
      mode = "In Key"
      action_chromatic = "Chromatic"
      action_fixed = "N/A"
      button_fixed:set_color('off')
   end

   self.line_a[1]:set_text("Scale selection:", 1)
   self.line_a[2]:set_text(scale.name)
   self.line_a[3]:set_text(keys[key])
   self.line_a[4]:set_text(mode)

   self.line_c[1]:set_split("Prev", keys[1])
   self.line_c[2]:set_split(keys[8], keys[3])
   self.line_c[3]:set_split(keys[10], keys[5])
   self.line_c[4]:set_split(keys[12], action_fixed)
   self.line_d[1]:set_split("Next", keys[6])
   self.line_d[2]:set_split(keys[11], keys[4])
   self.line_d[3]:set_split(keys[9], keys[2])
   self.line_d[4]:set_split(keys[7], action_chromatic)
end
