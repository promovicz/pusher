-- 
-- NotesActivity - note playing with pads
--

class 'NotesActivity' (PusherActivity)

function NotesActivity:__init()
   PusherActivity.__init(self, 'notes')

   self.fixed = false
   self.chromatic = false
   self.sequential = false
   self.stride = 3
   self.scale = 1
   self.key = 1
   self.orientation = 'horizontal'
   self.octave = 3
end

function NotesActivity:register(pusher)
   LOG("NotesActivity: register()")
   PusherActivity.register(self, pusher)

   self.pads = self:handle_control_group('pads')

   self:handle_control('scales')
   self:handle_control('stop')
   self:handle_control('octave-up')
   self:handle_control('octave-down')

   self:reconfigure_scale()
end

function NotesActivity:update()
   LOG("NotesActivity: update()")

   local c
   c = self.widgets['scales']
   c:set_color('on')
   c = self.widgets['stop']
   c:set_color('on')

   self:update_octave()
   self:update_pads()
end

function NotesActivity:set_chromatic(chromatic)
   LOG("NotesActivity: set_chromatic(", chromatic, ")")
   self.chromatic = chromatic
   self:reconfigure_pads()
end

function NotesActivity:set_sequential(sequential)
   LOG("NotesActivity: set_sequential(", sequential, ")")
   self.sequential = sequential
   self:reconfigure_pads()
end

function NotesActivity:set_fixed(fixed)
   LOG("NotesActivity: set_fixed(", fixed, ")")
   self.fixed = fixed
   self:reconfigure_pads()
end

function NotesActivity:set_stride(stride)
   LOG("NotesActivity: set_stride(", stride, ")")
   self.stride = stride
   self:reconfigure_pads()
end

function NotesActivity:set_orientation(orientation)
   LOG("NotesActivity: set_orientation(", orientation, ")")
   self.orientation = orientation
   self:reconfigure_pads()
end

function NotesActivity:set_scale(scale)
   LOG("NotesActivity: set_scale(", scale, ")")
   self.scale = scale
   self:reconfigure_scale()
end

function NotesActivity:set_key(key)
   LOG("NotesActivity: set_key(", KEYS_SHARP[key], ")")
   self.key = key
   self:reconfigure_scale()
end

local min_octave = 0
local max_octave = 7

function NotesActivity:set_octave(octave)
   LOG("NotesActivity: set_octave(", octave, ")")
   if (octave ~= self.octave) then
      self.octave = octave
      self:reconfigure_pads()
      self:update_octave()
   end
end

function NotesActivity:octave_up()
   self:set_octave(math.min(max_octave, self.octave + 1))
end

function NotesActivity:octave_down()
   self:set_octave(math.max(min_octave, self.octave - 1))
end


-- handle button press
function NotesActivity:on_button_press(control)
   local id = control.id
   if (id == 'octave-up') then
      self:octave_up()
   end
   if (id == 'octave-down') then
      self:octave_down()
   end
   if (id == 'scales') then
      self.pusher:show_scale_dialog()
   end
end

-- handle pad press
function NotesActivity:on_pad_press(control, value)
   local pitch = control.pitch
   if (pitch ~= nil) then
      LOG("pitch", pitch.midi)
      self.pusher.voices:trigger("foo", -1, -1, pitch.midi, value, true, false)
      control.pitch.playing = true
      self:update_pads()
   end
end

-- handle pad release
function NotesActivity:on_pad_release(control)
   local pitch = control.pitch
   if (pitch ~= nil) then
      self.pusher.voices:release("foo", -1, -1, pitch.midi, 0, false)
      control.pitch.playing = false
      self:update_pads()
   end
end

-- update octave buttons
function NotesActivity:update_octave()
   local up = self.widgets['octave-up']
   local dn = self.widgets['octave-down']
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
end

-- update all pads
function NotesActivity:update_pads()
   for _, pad in pairs(self.pads) do
      if (pad.pitch == nil) then
         pad:set_color('red')
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
end

-- reconfigure for changed scale
function NotesActivity:reconfigure_scale()
   self.pitches = build_scale_pitches(SCALES[self.scale], self.key)
   self:reconfigure_pads()
end

-- reconfigure pads for changed pitch/octave/scale/whatever
function NotesActivity:reconfigure_pads()
   local scale = SCALES[self.scale]
   for _, pad in pairs(self.pads) do
      -- pad offsets for arithmetics
      local x = pad.x - 1
      local y = pad.y - 1

      -- compute stride
      local stride
      if (self.sequential) then
         -- XXX should be width or height of pad array depending on orientation.
         --     this does not matter for the push but might for other controllers.
         stride = 8
      else
         if (self.chromatic) then
            stride = 5
         else
            stride = 3
         end
      end

      -- compute axis strides according to orientation
      local sx
      local sy
      if (self.orientation == 'horizontal') then
         sx = 1
         sy = stride
      else
         sx = stride
         sy = 1
      end

      -- offsets
      local ox = 0
      local oy = 0

      -- index of pad in 
      local index = sx * (ox + x) + sy * (oy + y)

      -- compute the pitch for the pad
      local offset = -1
      if (self.chromatic) then
         local o = math.floor(index / 12)
         local n = index % 12
         offset = (self.octave + o) * 12 + n
         if (not self.fixed) then
            offset = offset + (self.key - 1)
         end
      else
         local size = scale.length
         local o = math.floor(index / size)
         local no = index % size
         local n = scale.pitches[no + 1]
         offset = (self.octave + o) * 12 + n + (self.key - 1)
      end

      -- apply result to the pad
      if (offset >= 0 and offset < #self.pitches) then
         pad.pitch = self.pitches[offset + 1]
      else
         pad.pitch = nil
      end
   end

   -- redraw all pads
   self:update_pads()
end
