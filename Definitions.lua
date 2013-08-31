
SYSEX_START = {240, 71, 127, 21}

SET_MODE_LIVE = {98, 0, 1, 0}
SET_MODE_USER = {98, 0, 1, 1}

DISPLAY_CLEAR = {
 {28, 0, 0, 247},
 {29, 0, 0, 247},
 {30, 0, 0, 247},
 {31, 0, 0, 247}
}

DISPLAY_WRITE = {
 {24, 0, 69, 0},
 {25, 0, 69, 0},
 {26, 0, 69, 0},
 {27, 0, 69, 0}
}

DISPLAY_WRITE_END = {247}

BPM_MINIMUM = 6
BPM_MAXIMUM = 600

DIALS = {
   { id = 'tempo-knob', cc = 14, note = 10 },
   { id = 'swing-knob', cc = 15, note = 9 },

   { id = 'knob-1', cc = 71, note = 0, group = 'knobs' },
   { id = 'knob-2', cc = 72, note = 1, group = 'knobs' },
   { id = 'knob-3', cc = 73, note = 2, group = 'knobs' },
   { id = 'knob-4', cc = 74, note = 3, group = 'knobs' },
   { id = 'knob-5', cc = 75, note = 4, group = 'knobs' },
   { id = 'knob-6', cc = 76, note = 5, group = 'knobs' },
   { id = 'knob-7', cc = 77, note = 6, group = 'knobs' },
   { id = 'knob-8', cc = 78, note = 7, group = 'knobs' },

   { id = 'master-knob', cc = 79, note = 8 },
}

PALETTE_SIMPLE = {
   { name = 'black',     value = 0   },
   { name = 'half',      value = 1   },
   { name = 'half-slow', value = 2   },
   { name = 'half-fast', value = 3   },
   { name = 'full',      value = 4   },
   { name = 'full-slow', value = 5   },
   { name = 'full-fast', value = 6   },

   { name = 'on',  alias = 'full'  },
   { name = 'off', alias = 'black' }
}

PALETTE_BILED = {
   { name = 'black', value = 0 },

   { name = 'red-half',      value = 1 },
   { name = 'red-half-slow', value = 2 },
   { name = 'red-half-fast', value = 3 },
   { name = 'red',           value = 4 },
   { name = 'red-slow',      value = 5 },
   { name = 'red-fast',      value = 6 },

   { name = 'amber-half',      value = 7 },
   { name = 'amber-half-slow', value = 8 },
   { name = 'amber-half-fast', value = 9 },
   { name = 'amber',           value = 10 },
   { name = 'amber-slow',      value = 11 },
   { name = 'amber-fast',      value = 12 },

   { name = 'yellow-half',      value = 13 },
   { name = 'yellow-half-slow', value = 14 },
   { name = 'yellow-half-fast', value = 15 },
   { name = 'yellow',           value = 16 },
   { name = 'yellow-slow',      value = 17 },
   { name = 'yellow-fast',      value = 18 },

   { name = 'green-half',      value = 19 },
   { name = 'green-half-slow', value = 20 },
   { name = 'green-half-fast', value = 21 },
   { name = 'green',           value = 22 },
   { name = 'green-slow',      value = 23 },
   { name = 'green-fast',      value = 24 },

   { name = 'on',  alias = 'amber' },
   { name = 'off', alias = 'black' }
}

PALETTE_RGB = {
   { name = 'black', value = 0 },
   { name = 'darkgrey', value = 1 },
   { name = 'grey', value = 2 },
   { name = 'white', value = 3 },
   { name = 'red', value = 5 },
   { name = 'amber', value = 9 },
   { name = 'yellow', value = 13 },
   { name = 'lime', value = 17 },
   { name = 'green', value = 21 },
   { name = 'spring', value = 25 },
   { name = 'turquoise', value = 29 },
   { name = 'cyan', value = 33 },
   { name = 'sky', value = 37 },
   { name = 'ocean', value = 41 },
   { name = 'blue', value = 45 },
   { name = 'orchid', value = 49 },
   { name = 'magenta', value = 53 },
   { name = 'pink', value = 57 },

   { name = 'on',  alias = 'white' },
   { name = 'off', alias = 'black' }
}

function compile_palette(palette)
   local t = {}
   for _, defn in pairs(palette) do
      local real = defn
      if (defn.alias ~= nil) then
         real = t[defn.alias]
      end
      t[defn.name] = real
   end
   return t
end

PALETTES = {
   simple = compile_palette(PALETTE_SIMPLE),
   biled = compile_palette(PALETTE_BILED),
   rgb = compile_palette(PALETTE_RGB)
}

BUTTONS = {
   -- leftmost column

   { id = 'tap-tempo', cc = 3 },
   { id = 'metronome', cc = 9 },

   { id = 'undo', cc = 119 },
   { id = 'delete', cc = 118 },
   { id = 'double', cc = 117 },
   { id = 'quantize', cc = 116 },

   { id = 'fixed-length', cc = 90 },
   { id = 'duplicate', cc = 89 },
   { id = 'automation', cc = 88 },
   { id = 'new', cc = 87 },
   { id = 'record', cc = 86 },
   { id = 'play', cc = 85 },

   -- pad corner

   { id = 'master', cc = 28 },
   { id = 'stop', cc = 29 },

   -- above pads

   { id = 'track-select-1', cc = 20, palette = 'biled', group = 'track-select' },
   { id = 'track-select-2', cc = 21, palette = 'biled', group = 'track-select' },
   { id = 'track-select-3', cc = 22, palette = 'biled', group = 'track-select' },
   { id = 'track-select-4', cc = 23, palette = 'biled', group = 'track-select' },
   { id = 'track-select-5', cc = 24, palette = 'biled', group = 'track-select' },
   { id = 'track-select-6', cc = 25, palette = 'biled', group = 'track-select' },
   { id = 'track-select-7', cc = 26, palette = 'biled', group = 'track-select' },
   { id = 'track-select-8', cc = 27, palette = 'biled', group = 'track-select' },

   { id = 'track-state-1', cc = 102, palette = 'rgb', group = 'track-state' },
   { id = 'track-state-2', cc = 103, palette = 'rgb', group = 'track-state' },
   { id = 'track-state-3', cc = 104, palette = 'rgb', group = 'track-state' },
   { id = 'track-state-4', cc = 105, palette = 'rgb', group = 'track-state' },
   { id = 'track-state-5', cc = 106, palette = 'rgb', group = 'track-state' },
   { id = 'track-state-6', cc = 107, palette = 'rgb', group = 'track-state' },
   { id = 'track-state-7', cc = 108, palette = 'rgb', group = 'track-state' },
   { id = 'track-state-8', cc = 109, palette = 'rgb', group = 'track-state' },

   -- right of pads

   { id = 'measure-32t', cc = 43, palette = 'biled', group = 'measure' },
   { id = 'measure-32',  cc = 42, palette = 'biled', group = 'measure' },
   { id = 'measure-16t', cc = 41, palette = 'biled', group = 'measure' },
   { id = 'measure-16',  cc = 40, palette = 'biled', group = 'measure' },
   { id = 'measure-8t',  cc = 39, palette = 'biled', group = 'measure' },
   { id = 'measure-8',   cc = 38, palette = 'biled', group = 'measure' },
   { id = 'measure-4t',  cc = 37, palette = 'biled', group = 'measure' },
   { id = 'measure-4',   cc = 36, palette = 'biled', group = 'measure' },

   -- rightmost column

   { id = 'volume', cc = 114 },
   { id = 'pan-send', cc = 115 },
   { id = 'track', cc = 112 },
   { id = 'clip', cc = 113 },
   { id = 'device', cc = 110 },
   { id = 'browse', cc = 111 },

   { id = 'back', cc = 62 },
   { id = 'forward', cc = 63 },
   { id = 'mute', cc = 60 },
   { id = 'solo', cc = 61 },
   { id = 'scales', cc = 58 },
   { id = 'user', cc = 59 },
   { id = 'repeat', cc = 56 },
   { id = 'accent', cc = 57 },
   { id = 'octave-down', cc = 54, group = 'octave' },
   { id = 'octave-up',   cc = 55, group = 'octave' },

   { id = 'add-effect', cc = 52 },
   { id = 'add-track', cc = 53 },
   { id = 'note', cc = 50 },
   { id = 'session', cc = 51 },
   { id = 'select', cc = 48 },
   { id = 'shift', cc = 49 },

   { id = 'cursor-left',  cc = 44, group = 'cursor' },
   { id = 'cursor-right', cc = 45, group = 'cursor' },
   { id = 'cursor-up',    cc = 46, group = 'cursor' },
   { id = 'cursor-down',  cc = 47, group = 'cursor' }
}
