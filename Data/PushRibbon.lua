
-- Sets ribbon mode (expects 1 byte with mode)
RIBBON_SET_MODE = {99, 0, 1}
-- Sets ribbon leds (XXX expects 3 bytes or maybe 6)
RIBBON_SET_LEDS = {100, 0, 8}

-- Ribbon modes
RIBBON_MODE_CUSTOM_PITCHBEND = 0
RIBBON_MODE_CUSTOM_VOLUME = 1
RIBBON_MODE_CUSTOM_PAN = 2
RIBBON_MODE_CUSTOM_DISCRETE = 3
RIBBON_MODE_CUSTOM_FREE = 4
RIBBON_MODE_PITCHBEND = 5
RIBBON_MODE_VOLUME = 6
RIBBON_MODE_PAN = 7
RIBBON_MODE_DISCRETE = 8

-- Definitions for ribbon modes
RIBBON_MODE_DEFINITIONS = {
   { name = "custom-pitchbend",
     value = RIBBON_MODE_CUSTOM_PITCHBEND },
   { name = "custom-volume",
     value = RIBBON_MODE_CUSTOM_VOLUME },
   { name = "custom-pan",
     value = RIBBON_MODE_CUSTOM_PAN },
   { name = "custom-discrete",
     value = RIBBON_MODE_CUSTOM_DISCRETE },
   { name = "custom-free",
     value = RIBBON_MODE_CUSTOM_FREE },
   { name = "pitchbend",
     value = RIBBON_MODE_PITCHBEND },
   { name = "volume",
     value = RIBBON_MODE_VOLUME },
   { name = "pan",
     value = RIBBON_MODE_PAN },
   { name = "discrete",
     value = RIBBON_MODE_DISCRETE }
}

-- Compiler for ribbon modes
function build_ribbon_modes(definitions)
   local modes = { }
   for i, d in pairs(definitions) do
      modes[d.name] = d
   end
   return modes
end

-- Compiled ribbon modes indexed by name
RIBBON_MODES = build_ribbon_modes(RIBBON_MODE_DEFINITIONS)
