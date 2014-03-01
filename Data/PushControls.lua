
DIALS = {
   -- leftmost colum

   { id = 'tempo-knob', cc = 14, note = 10 },
   { id = 'swing-knob', cc = 15, note = 9 },

   -- above display
   { id = 'knob-1', cc = 71, note = 0, group = 'knobs' },
   { id = 'knob-2', cc = 72, note = 1, group = 'knobs' },
   { id = 'knob-3', cc = 73, note = 2, group = 'knobs' },
   { id = 'knob-4', cc = 74, note = 3, group = 'knobs' },
   { id = 'knob-5', cc = 75, note = 4, group = 'knobs' },
   { id = 'knob-6', cc = 76, note = 5, group = 'knobs' },
   { id = 'knob-7', cc = 77, note = 6, group = 'knobs' },
   { id = 'knob-8', cc = 78, note = 7, group = 'knobs' },

   -- master
   { id = 'master-knob', cc = 79, note = 8 },
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
