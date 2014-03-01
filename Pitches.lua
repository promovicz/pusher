
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
function build_keys_combined()
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
KEYS_COMBINED = build_keys_combined()

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

-- table of all midi pitches
PITCHES = build_pitches()

-- scale definitions
SCALE_DEFINITIONS = {
   {
      name = "Major",
      pitches = { 0,2,4,5,7,9,11 }
   },
   {
      name = "Pentatonic Major",
      pitches = { 0,2,4,7,9 }
   },
}

function build_scale(definition)
   definition.length = #definition.pitches
   definition.diatonic = definition.length == 8 and definition.pitches[8] == 12
   return definition
end

function build_scales()
   local scales = { }
   for _, definition in pairs(SCALE_DEFINITIONS) do
      scales[_] = build_scale(definition)
   end
   return scales
end

SCALES = build_scales()

function build_scale_pitches(scale, key)
   LOG("building scale pitches for", KEYS_SHARP[key], scale.name)

   local scalepitches = { }

   local key_offset = key - 1
   
   for _, pitch in pairs(PITCHES) do
      -- index of this pitch
      local pitch_index = pitch.midi
      -- compute offset from tonic
      local pitch_offset = (pitch_index - key_offset) % 12

      LOG("pitch", pitch_index, "offset", pitch_offset)

      -- determine scale relationship
      local relationship = 'none'
      if (pitch_offset == 0) then
         LOG("tonic")
         -- this pitch is the tonic and in the scale
         relationship = 'tonic'
      else
         -- check if this pitch is in the scale
         for _, p in pairs(scale.pitches) do
            if (p < 12 and p == pitch_offset) then
               LOG("member")
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
