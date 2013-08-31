
-- names of all keys in "sharp" notation
KEYS_SHARP = {
   "C",  "C#", "D",  "D#", "E",  "F",
   "F#", "G",  "G#", "A",  "A#", "B"
}

-- names of all keys in "flat" notation
KEYS_FLAT = {
   "C",  "Db", "D",  "Eb", "E",  "F",
   "Gb", "G",  "Ab", "A",  "Bb", "B"
}

-- combines the above tables to "sharp/flat" notation
function build_keys_both()
   local result = { }
   for i, sharp in pairs(KEYS_SHARP) do
      local flat = KEYS_FLAT[i]
      if (sharp == flat) then
         result[i] = sharp
      else
         result[i] = sharp .. "/" .. flat
      end
   end
   return result
end

-- names of all keys in "sharp/flat" notation
KEYS_BOTH = build_keys_both()

-- scale definitions
SCALES = {
   {
      name = "Major",
      pitches = { 1,3,5,6,8,10,12 }
   },
   {
      name = "Pentatonic Major",
      pitches = { 1,3,5,8,10 }
   },
   {
      name = "Blues Major",
      pitches = { 1,4,6,7,8,10 }
   },
   {
      name = "Minor",
      pitches = { 1,3,4,6,8,9,11 }
   },
   {
      name = "Melodic Minor",
      pitches = { 1,3,4,6,8,10,12 }
   },
   {
      name = "Harmonic Minor",
      pitches = { 1,3,4,6,8,9,12 }
   },
   {
      name = "Pentatonic Minor",
      pitches = { 1,4,6,8,11 }
   }
}

-- builds a table of all midi pitches
function build_pitches()
   local pitches = { }
   for midinote in range(0, 127) do
      local octave = math.floor(midinote / 12)
      local key = midinote % 12 + 1
      local pitch = {
         midi = midinote,
         octave = octave, 
         key = key
      }
      pitches[midinote + 1] = pitch
   end
   return pitches
end

PITCHES = build_pitches()

function build_scale_pitches(scale, key)
   LOG("building scale pitches for", KEYS_SHARP[key], scale.name)

   local scalepitches = { }

   local key_offset = key - 1
   
   for _, pitch in pairs(PITCHES) do
      -- index of this pitch
      local pitch_index = pitch.midi
      -- compute offset from tonic
      local pitch_offset = (pitch_index - key_offset) % 12

      -- determine scale relationship
      local relationship = 'none'
      if (pitch_offset == 0) then
         -- this pitch is the tonic and in the scale
         relationship = 'tonic'
      else
         -- check if this pitch is in the scale
         for _, p in pairs(scale.pitches) do
            if (p - 1 == pitch_offset) then
               relationship = 'member'
            end
         end
      end

      -- build scalepitch object
      local scalepitch = {
         midi = pitch.midi,
         octave = pitch.octave,
         key = key,
         scale_offset = pitch_offset,
         scale_relationship = relationship
      }
      scalepitches[_] = scalepitch

      -- if (relationship ~= 'none') then
      --    LOG("pitch", pitch.midi, "key", KEYS_SHARP[pitch.key], "is", relationship)
      -- end
   end

   return scalepitches
end
