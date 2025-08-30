---Acawe. Awake for crow.
-- → 1 nudge seq1 (+), seq2 (-)
-- → 2 scale notes
--   1 trigger →
--   2 note    →
--   3 seq1    →
--   4 seq2    →
--
-- by xmacex based on tehn's

scales={none      = 'none',
	plentiful = {1,2,3,4,5,6,7,8,9,10,11,12},
	modest    = {1,  3,4,5,  7,8,     11,12},
	ohdear    = {    3,4,         10       }}
scalenames={'none', 'plentiful', 'modest', 'ohdear'}

-- TODO somehow calculating them on the go makes them unavailable to calls
-- scalenames={}
-- for k, _ in ipairs(scales) do table.insert(scalenames, k) end

function init()

   public{one     = sequins{1,0,3,5,6,7,8,7}/12}:range(0, 12)
   public{one_len = 8}
   public{two     = sequins{5,7,0,0,0,0,0,0}/12}:range(0, 12)
   public{two_len = 7}
   public{scale   = 'plentiful'}
      :options{'none', 'plentiful', 'modest', 'ohdear'} -- TODO how to use scalenames?
      :action(set_scale)
   wsmap={}; wsmap[1]=public.two; wsmap[3]=public.one

   input[1]{mode='window', windows={-3,3},  window=function(w) nudge(wsmap[w]) end}
   input[2]{mode='window', windows={0,1,2}, window=function(w) public.scale = scalenames[w] end}

   output[1].action = pulse()

   clock.run(step)
end

function step()
   while true do
      clock.sync(1/4)

      local o = public.one()
      local t = public.two()

      if public.one.ix == public.one_len then public.one:reset() end
      if public.two.ix == public.two_len then public.two:reset() end

      if o > 0 then output[1]() end
      output[2].volts = o+t
      output[3].volts = o
      output[4].volts = t
   end
end

function nudge(sequence)
   if sequence then
      for i=1,#sequence do
         if math.random() > 1/12 * 2 then
	    sequence[i] = math.max(0, math.min(sequence[i]+math.random() * 2 - 1, 12))
	    -- FIXME: doesn't sync public. Is it that table thing again? I'm confused
	 end
      end
   end
end

function set_scale(scale)
   print("setting scale "..scale)
   output[2].scale(scales[scale])
end

-- Local Variables:
-- flycheck-luacheck-standards: ("lua51+crow")
-- End:
