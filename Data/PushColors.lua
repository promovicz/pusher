
-- palette for monochromatic buttons
--
-- One color, two brightness levels, two blink speeds.
--
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

-- palette for "two-LED" buttons
--
-- Four colours, two brightness levels, two blink speeds.
-- 
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

-- palette for "RGB" buttons
--
-- A few fixed colors (actually rather lame)
--
-- XXX Not complete - transcribe from Live
-- XXX Should add true RGB values to table
--
PALETTE_RGB = {
   { value = 0,  rgb = {  0,  0,  0}},
   { value = 1,  rgb = { 30, 30, 30}},
   { value = 2,  rgb = {127,127,127}},
   { value = 3,  rgb = {255,255,255}},
   { value = 4,  rgb = {255, 76, 76}},
   { value = 5,  rgb = {255,  0,  0}},
   { value = 6,  rgb = { 89,  0,  0}},
   { value = 7,  rgb = { 25,  0,  0}},
   { value = 8,  rgb = {255,189,108}},
   { value = 9,  rgb = {255, 84,  0}},
   { value = 10, rgb = { 89, 29,  0}},
   { value = 11, rgb = { 39, 27,  0}},
   { value = 12, rgb = {255,255, 76}},
   { value = 13, rgb = {255,255,  0}},
   { value = 14, rgb = { 89, 89,  0}},
   { value = 15, rgb = { 25, 25,  0}},

   { value = 16, rgb = {136,255, 76}},
   { value = 17, rgb = { 84,255,  0}},
   { value = 18, rgb = { 29, 89,  0}},
   { value = 19, rgb = { 20, 43,  0}},
   { value = 20, rgb = { 76,255, 76}},
   { value = 21, rgb = {  0,255,  0}},
   { value = 22, rgb = {  0, 89,  0}},
   { value = 23, rgb = {  0, 25,  0}},
   { value = 24, rgb = { 76,255, 94}},
   { value = 25, rgb = {  0,255, 25}},
   { value = 26, rgb = {  0, 89, 13}},
   { value = 27, rgb = {  0, 25,  2}},
   { value = 28, rgb = { 76,255,136}},
   { value = 29, rgb = {  0,255, 85}},
   { value = 30, rgb = {  0, 89, 29}},
   { value = 31, rgb = {  0, 31, 18}},

   { value = 32, rgb = { 76,255,183}},
   { value = 33, rgb = {  0,255,153}},
   { value = 34, rgb = {  0, 89, 53}},
   { value = 35, rgb = {  0, 25, 18}},
   { value = 36, rgb = { 76,195,255}},
   { value = 37, rgb = {  0,169,255}},
   { value = 38, rgb = {  0, 65, 82}},
   { value = 39, rgb = {  0, 16, 25}},
   { value = 40, rgb = { 76,136,255}},
   { value = 41, rgb = {  0, 85,255}},
   { value = 42, rgb = {  0, 29, 89}},
   { value = 43, rgb = {  0,  8, 25}},
   { value = 44, rgb = { 76, 76,255}},
   { value = 45, rgb = {  0,  0,255}},
   { value = 46, rgb = {  0,  0, 89}},
   { value = 47, rgb = {  0,  0, 25}},

   { value = 48, rgb = {135, 76,255}},
   { value = 49, rgb = { 84,  0,255}},
   { value = 50, rgb = { 25,  0,100}},
   { value = 51, rgb = { 15,  0, 48}},
   { value = 52, rgb = {255, 76,255}},
   { value = 53, rgb = {255,  0,255}},
   { value = 54, rgb = { 89,  0, 89}},
   { value = 55, rgb = { 25,  0, 25}},
   { value = 56, rgb = {255, 76,135}},
   { value = 57, rgb = {255,  0, 84}},
   { value = 58, rgb = { 89,  0, 29}},
   { value = 59, rgb = { 34,  0, 19}},
   { value = 60, rgb = {255, 21,  0}},
   { value = 61, rgb = {153, 53,  0}},
   { value = 62, rgb = {121, 81,  0}},
   { value = 63, rgb = { 67,100,  0}},

   { name = 'red',       alias = "c5" },
   { name = 'amber',     alias = "c9" },
   { name = 'yellow',    alias = "c13" },
   { name = 'lime',      alias = "c17" },
   { name = 'green',     alias = "c21" },
   { name = 'spring',    alias = "c25" },
   { name = 'turquoise', alias = "c29" },
   { name = 'cyan',      alias = "c33" },
   { name = 'sky',       alias = "c37" },
   { name = 'ocean',     alias = "c41" },
   { name = 'blue',      alias = "c45" },
   { name = 'orchid',    alias = "c49" },
   { name = 'magenta',   alias = "c53" },
   { name = 'pink',      alias = "c57" },

   { name = 'black', alias = "c0"},
   { name = 'white', alias = "c3"},
   { name = 'grey1', alias = "c1"},
   { name = 'grey2', value = 117, rgb = { 64, 64, 64}},
   { name = 'grey3', value = 118, rgb = {117,117,117}},
   { name = 'grey4', alias = "c2"},
   
   { name = 'darkgrey',  alias = 'grey1'},
   { name = 'grey',      alias = 'grey2'},
   { name = 'lightgrey', alias = 'grey4'},

   { name = 'on',  alias = 'white' },
   { name = 'off', alias = 'black' }
}

function compile_palette(palette)
   local t = {}
   for _, defn in pairs(palette) do
      local real = defn
      if (defn.name == nil) then
         defn.name = "c" .. defn.value
      end
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
