-- 
-- NotesActivity - note playing with pads
--

class 'NotesActivity' (PusherActivity)

function NotesActivity:__init()
   PusherActivity.__init(self, 'notes')
   self.mode = 'chromatic'
   self.octave = -1
end

function NotesActivity:register(pusher)
   LOG("NotesActivity: register()")
   PusherActivity.register(self, pusher)

   self:handle_control('scales')
   self:handle_control('octave-up')
   self:handle_control('octave-down')

   self.pads = self:handle_control_group('pads')

   self:set_scale(SCALES[1], 1)
   self:set_octave(2)

   self:update_pitches()

   self:update()
end

function NotesActivity:update()
   LOG("NotesActivity: update()")

   local c
   c = self.controls['scales']
   c:set_color('on')
end

local max_octave = 8

function NotesActivity:set_octave(octave)
   if (self.octave ~= octave) then
      self.octave = octave
      self:update_octave()
   end
end

function NotesActivity:set_scale(scale, key)
   self.scale_pitches = build_scale_pitches(scale, key)
   self:update_pitches()
end

function NotesActivity:octave_up()
   self:set_octave(math.min(max_octave, self.octave + 1))
end

function NotesActivity:octave_down()
   self:set_octave(math.max(0, self.octave - 1))
end

function NotesActivity:update_octave()
   local up = self.controls['octave-up']
   local dn = self.controls['octave-down']
   if (self.octave == 0) then
      dn:set_color('off')
   else
      dn:set_color('on')
   end
   if (self.octave == max_octave) then
      up:set_color('off')
   else
      up:set_color('on')
   end
   self:update_pitches()
end

function NotesActivity:update_pitches()
   local sp = self.scale_pitches
   for _, pad in pairs(self.pads) do
      local pitch = self:get_pitch(pad)
      local psp = sp[pitch + 1]
      pad.pitch = psp
      if (psp == nil) then
         pad:set_color('off')
      else
         self:update_pad(pad)
      end
   end
end

function NotesActivity:update_pads()
   for _, pad in pairs(self.pads) do
      self:update_pad(pad)
   end
end

function NotesActivity:update_pad(pad)
   if (pad.pitch == nil) then
      pad:set_color('off')
   elseif (pad.pitch.playing) then
      pad:set_color('green')
   else
      local pr = pad.pitch.scale_relationship
      if (pr == 'tonic') then
         pad:set_color('sky')
      elseif (pr == 'member') then
         pad:set_color('white')
      else
         pad:set_color('off')
      end
   end
end

function NotesActivity:get_voice(control)
   return self.id .. "-" .. control.id
end

function NotesActivity:get_pitch(control)
   if (self.mode == 'chromatic') then
      return self.octave * 12 + (control.y - 1) * 8 + (control.x - 1)
   end
   if (self.mode == 'hands') then
      local octave = self.octave
      local pitch = control.x - 1
      if (control.x > 4) then
         octave = octave + 2
         pitch = pitch - 4
      end
      pitch = pitch + self.octave * 12 + (control.y - 1) * 4
      return pitch
   end

end

function NotesActivity:on_button_press(control)
   if (control.id == 'octave-up') then
      self:octave_up()
   end
   if (control.id == 'octave-down') then
      self:octave_down()
   end
end

function NotesActivity:on_pad_press(control, value)
   local pitch = control.pitch
   LOG("pitch", pitch.midi)
   self.pusher.voices:trigger(self:get_voice(control), -1, -1, pitch.midi, value, true, false)
   control.pitch.playing = true
   self:update_pads()
end

function NotesActivity:on_pad_release(control)
   local pitch = control.pitch
   self.pusher.voices:release(self:get_voice(control), -1, -1, pitch.midi, 0, false)
   control.pitch.playing = false
   self:update_pads()
end
