
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
