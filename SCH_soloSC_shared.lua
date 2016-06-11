--------------------------------------
-- GET NB STRATAGEMS
--------------------------------------
-- Gets the current number of available strategems based on the recast remaining
-- and the level of the sch.
function getNbStratagems()
    -- returns recast in seconds.
    local allRecasts = windower.ffxi.get_ability_recasts()
    local stratsRecast = allRecasts[231]
    local maxStrategems = math.floor((player.main_job_level + 10) / 20)
    local fullRechargeTime = 4*60
    local currentCharges = math.floor(maxStrategems - maxStrategems * stratsRecast / fullRechargeTime)
    return currentCharges
end

function displayStratagems()
  add_to_chat(debug.color.info,'===== '..tostring(getNbStratagems()-1)..' stratagemes restants =====')
end

--------------------------------------
-- SOLO SKILLCHAIN
--------------------------------------
--[[
@param integer|string nbSC : Number of SkillChains to do, between 1 and 3 or "max".
@param string elementEnd : Final SC element (Fusion, Scission, ...).
@param bool STFU : if true, no message in party. Default is false.

Usage example : 
/console gs c soloSC 1 Fusion
=> will do 1 skillchain, ending with Fusion : Fire, Thunder
/console gs soloSC 3 Fragmentation
=> will do 3 skillchains, ending with Fragmentation : Stone, Water, Blizzard, Water
/console gs soloSC max Fusion
=> will spend all stratagems to perform skillchains, ending with Fusion
/console gs c soloSC 1 Fusion true
=> will do 1 SC Fusion, but nothing displayed in party chat
--]]
function soloSkillchain(nbSC,elementEnd,STFU)

--**************************************************
-- If you have access to helix II, false into true
local accessToHelixII = false
--**************************************************

add_to_chat(debug.color.info,'========== soloSkillchain ==========')

  elementEnd = tostring(elementEnd)
  if not STFU then
    STFU=false
  elseif STFU=='true' then
    STFU=true
  else
    STFU=false
  end

  local plural = ''

-- Checking parameters
  if not elementEnd then
    errlog("Shitty parameters : soloSkillchain("..tostring(nbSC)..","..tostring(elementEnd)..")")
    return
  elseif elementEnd=='' then
    errlog("Shitty parameters : soloSkillchain("..tostring(nbSC)..","..tostring(elementEnd)..")")
  end --if not elementEnd

  if not info.skillchain.tier1:contains(elementEnd) and not info.skillchain.tier2:contains(elementEnd) then
    errlog('Finale SC not recognized : '..elementEnd)
    return
  end -- if not info.skillchain.tier1:contains(elementEnd) ...  

  local nbStrat = getNbStratagems()

  if not nbSC then
    errlog("Shitty parameters : soloSkillchain("..tostring(nbSC)..","..tostring(elementEnd)..")")
    return
  else
    if nbSC == 'max' then
      nbSC = nbStrat-1
      if buffactive["Tabula Rasa"] then nbSC = 4 end
	end

    nbSC = tonumber(nbSC)
	if nil==nbSC then
      errlog("Shitty parameters : nbSC isn't a number")
      return
    else
      if nbSC>1 then plural='s' end

      if nbSC>4 then
        errlog("Shitty parameters : soloSkillchain("..tostring(nbSC)..","..tostring(elementEnd)..")")
        return
	  elseif (nbSC==2 and nbStrat < 3) or (nbSC==3 and nbStrat < 4) or (nbSC==4 and nbStrat < 5) then
        errlog("Not enough stratagems for "..tostring(nbSC).." skillchain"..plural.." : "..tostring(nbStrat)..'/'..tostring(nbSC+1))
        return
      end --if nbSC>4
	end --if nil==nbSC then
  end --else [if not nbSC]

-- Paramètres OK.

-- Checking you didn't forget Dark Arts
if buffactive["Dark Arts"]~=nil and buffactive["Addendum: Black Arts"]~=nil then
  errlog("ABORT : 'Dark Arts' required")
  return
end

-- Retrieving lists of spells needed
  spellsSC = getSpellsForSC(nbSC,elementEnd)

-- Managing special cases : 
-- only 1 SC, starting with helix, and ending with an element => it doens't work, don't ask me why
if (nbSC==1)
and (spellsSC[0].magic=="Luminohelix" or spellsSC[0].magic=="Noctohelix")
and not(spellsSC[1].magic=="Luminohelix")
and not(spellsSC[1].magic=="Noctohelix") then
  errlog("Combination not working : helix => element doesn't trigger a SC.")
  errlog("1 "..elementEnd.." = "..spellsSC[0].magic.." => "..spellsSC[1].magic)
  errlog("However, preceding it with one more SC will work : transfixion/compression => element.")
  return false
end
  
  local wait = {}
  wait.postImmanence = 1
  local commandSoloSC = '' -- will contain the final command to send

  -- Let's build the command. And if not STFU, let's build the chat spam too muahaha.

  commandSoloSC = ''
  if not STFU then
    commandSoloSC = commandSoloSC..'input /p Starting '..tostring(nbSC)..' Skillchain'..plural..' : '
	for i=1,nbSC,1 do
	  if i>1 then commandSoloSC = commandSoloSC..',' end
	  commandSoloSC = commandSoloSC..' '..spellsSC[i].SC
	end -- for
	commandSoloSC = commandSoloSC..' <call20>;'
  end --if not STFU

    -- If twice the same helix is used : abort
  local helixUsed = {}
  helixUsed.light = false
  helixUsed.dark = false
  local msgDebug = ''
  
-------------
-- ZE LOOP
-------------
  for i=0,nbSC,1 do
  commandCurrentRound = ''
    -- Multiple helix usage check
    if spellsSC[i].magic =='Luminohelix' then
      if helixUsed.light==true then
	    -- already used, recast will prevent to chain
		if not (accessToHelixII==true) then
	      errlog("Recast trouble : Luminohelix required more than once, aborting.")
	      return
		else
		  spellsSC[i].magic = '"Luminohelix II"'
		  spellsSC[i].castTime = spellsSC[i].castTime+1
		end -- if not (accessToHelixII==true)
	  else
	    helixUsed.light=true
	  end
    end -- if spellsSC[i].magic =='Luminohelix'

    if spellsSC[i].magic =='Noctohelix' then
      if helixUsed.dark==true then
	    if not (accessToHelixII==true) then
	      errlog("Recast trouble : Noctohelix required more than once, aborting.")
	      return
		else
		  spellsSC[i].magic = '"Noctohelix II"'
		  spellsSC[i].castTime = spellsSC[i].castTime+1
		end -- if not (accessToHelixII==true)
	  else
	    helixUsed.dark=true
	  end --if helixUsed.dark==true
    end -- if spellsSC[i].magic =='Noctohelix'
	
    commandCurrentRound = commandCurrentRound..'input /ja Immanence <me>;wait '..tostring(wait.postImmanence)..';'
    commandCurrentRound = commandCurrentRound..'input /ma '..spellsSC[i].magic..' <t>;'
	
	-- calculating waiting times
	wait.windowMB = 7
	if (i>2) then
	  -- we got less time to chain SC, let's shorten the wait
	  wait.windowMB = 6
	end
	wait.beforeNextSpell = spellsSC[i].castTime -- between "/p MB NOW !" and next Immanence
	castTimeSpellAfter = 0
	if(i<nbSC) then
	  castTimeSpellAfter = spellsSC[i+1].castTime
	  -- if this is not the first spell, we maximise the MB window to 7s. 8 sometime fails to SC.
	  if (i>0) then
	    wait.beforeNextSpell = math.max(0,(wait.windowMB - castTimeSpellAfter - wait.postImmanence))
	  end
	end
--add_to_chat(200,tostring(i)..' : '..spellsSC[i].magic..', cast='..tostring(spellsSC[i].castTime)..', wait.beforeNextSpell='..tostring(wait.beforeNextSpell))

	-- info sur la SC en chan pt
	if not STFU and i>0 then
	  commandCurrentRound = commandCurrentRound..'input /p '..spellsSC[i].SC..' in '..tostring(spellsSC[i].castTime)..'s : '
      commandCurrentRound = commandCurrentRound..'MB '..info.skillchain[ spellsSC[i].SC ].MB
	  if i<nbSC then -- we're not done yet, we inform the pt
	    commandCurrentRound = commandCurrentRound..' (~'..tostring(wait.beforeNextSpell + wait.postImmanence + castTimeSpellAfter)..'s wait before next MB window)'
	  end --if i<nbSC
	  commandCurrentRound = commandCurrentRound..';'
	end -- if not STFU and i>0

	if i==nbSC then 
	  commandCurrentRound = commandCurrentRound.."input /echo ========== DONE ==========;"
	end
	
    commandCurrentRound = commandCurrentRound..'wait '..tostring(spellsSC[i].castTime)..';'
	
	if(i>0) then
	  if not STFU then
	    -- MB NOW !
	    commandCurrentRound = commandCurrentRound..'input /p MB '..info.skillchain[ spellsSC[i].SC ].MB..' NOW !;'
	  end

	  if i<nbSC then
	    -- "+1" because we need one second after the cast to be able to JA
	    commandCurrentRound = commandCurrentRound..'wait '..tostring(wait.beforeNextSpell + 1)..';'
	  end --if i<nbSC
	else
	    commandCurrentRound = commandCurrentRound..'wait 1;'
	end --if(i>0)
	commandSoloSC = commandSoloSC..commandCurrentRound
  end  -- for

  --add_to_chat(debug.color.default,commandSoloSC)  
  send_command(commandSoloSC)
end



-- Returns the spells required for the SC
-- do not call this function alone. It has to be called from soloSC and only there.
-- @param nbSC : number of SC to do
-- @param elementSCFinale : ex 'Liquefaction' /!\ NO CHECKING, 'Light' => non handled error
-- @return tabSpells
function getSpellsForSC(nbSC,elementSCFinale)
  nbSC = tonumber(nbSC)
  if nbSC>4 then nbSC=4 end
  if nbSC<1 then
    errlog('Dafuq ? '..tostring(nbSC)..' SC ?')
	return spellsSC
  end
  
  local spellsSC = {}
  spellsSC[0] = {}
  spellsSC[0].magic = 'undefined'
  spellsSC[0].castTime = -1
  spellsSC[0].SC = ''
  
  spellsSC[1] = {}
  spellsSC[1].magic = 'undefined'
  spellsSC[1].castTime = -1
  spellsSC[1].SC = ''
  
  spellsSC[2] = {}
  spellsSC[2].magic = 'undefined'
  spellsSC[2].castTime = -1
  spellsSC[2].SC = ''
  
  spellsSC[3] = {}
  spellsSC[3].magic = 'undefined'
  spellsSC[3].castTime = -1
  spellsSC[3].SC = ''
  
  spellsSC[4] = {}
  spellsSC[4].magic = 'undefined'
  spellsSC[4].castTime = -1
  spellsSC[4].SC = ''


  local wait = {}
  wait.postImmanence = 1
  local castTime = {}
  
  --**************************************************
  -- CONSTANTS
  -- tune this according to your stuff and skill
  castTime.helix = 6
  castTime.tier1 = 3
  --**************************************************


  -- Wall of shit defining all the elements used for SC.
  local dataSC = {}
  local el = '' -- For reading convenience, will store current SC element.
    
  -- Tier 1
  el = 'Transfixion'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Noctohelix'
  dataSC[el].open.SC = 'Compression'
  dataSC[el].open.castTime = castTime.helix
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Luminohelix'
  dataSC[el].close.castTime = castTime.helix

  el = 'Compression'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Luminohelix'
  dataSC[el].open.SC = 'Transfixion'
  dataSC[el].open.castTime = castTime.helix
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Noctohelix'
  dataSC[el].close.castTime = castTime.helix
  
  -- some of the following settings are arbitrary : let's prioritize elemental to light/dark, and focus on most powerful ones : fire/blizzard/thunder
  el = 'Liquefaction'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Thunder'
  dataSC[el].open.SC = 'Impaction'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Fire'
  dataSC[el].close.castTime = castTime.tier1
  
  el = 'Scission'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Fire'
  dataSC[el].open.SC = 'Liquefaction'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Stone'
  dataSC[el].close.castTime = castTime.tier1
  
  el = 'Reverberation'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Stone'
  dataSC[el].open.SC = 'Scission'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Water'
  dataSC[el].close.castTime = castTime.tier1
  
  el = 'Detonation'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Thunder'
  dataSC[el].open.SC = 'Impaction'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Aero'
  dataSC[el].close.castTime = castTime.tier1
  
  el = 'Induration'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Water'
  dataSC[el].open.SC = 'Reverberation'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Blizzard'
  dataSC[el].close.castTime = castTime.tier1
  
  el = 'Impaction'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Blizzard'
  dataSC[el].open.SC = 'Induration'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Thunder'
  dataSC[el].close.castTime = castTime.tier1
 
 
  -- Tier 2
  
  el = 'Fusion'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Fire'
  dataSC[el].open.SC = 'Liquefaction'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Thunder'
  dataSC[el].close.castTime = castTime.tier1
  
  el = 'Gravitation'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Aero'
  dataSC[el].open.SC = 'Detonation'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Noctohelix'
  dataSC[el].close.castTime = castTime.helix
  
  el = 'Fragmentation'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Blizzard'
  dataSC[el].open.SC = 'Induration'
  dataSC[el].open.castTime = castTime.tier1
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Water'
  dataSC[el].close.castTime = castTime.tier1
  
  el = 'Distortion'
  dataSC[el] = {}
  dataSC[el].open = {}
  dataSC[el].open.magic = 'Luminohelix'
  dataSC[el].open.SC = 'Transfixion'
  dataSC[el].open.castTime = castTime.helix
  dataSC[el].close = {}
  dataSC[el].close.magic = 'Stone'
  dataSC[el].close.castTime = castTime.tier1

  
  local elementSC = {} -- SC element for each step
  elementSC[1] = ''
  elementSC[2] = ''
  elementSC[3] = ''
  elementSC[4] = ''
  
  elementSC[nbSC] = elementSCFinale
  
  -- Now we define the spells to chain. Warning, wall of code incoming.
  local step
  local elementSCEnCours

  for step=nbSC,1,-1 do
    -- Retrieving the SC element for this step.
    elementSCEnCours = elementSC[step]
	-- Retrieving spell.
	spellsSC[step].SC	= elementSCEnCours
	spellsSC[step].magic= dataSC[elementSCEnCours].close.magic
	spellsSC[step].castTime	= dataSC[elementSCEnCours].close.castTime

	-- Let's define the SC required for previous step.
	if step>1 then
	  elementSC[step-1] = dataSC[elementSCEnCours].open.SC
	end
  end

  spellsSC[0].magic= dataSC[ elementSC[1] ].open.magic
  spellsSC[0].castTime = dataSC[ elementSC[1] ].open.castTime
  -- Oh look, we're already done ! I'm a genius. #hohoho

  return spellsSC
end -- function getSpellsForSC


function errlog(msg) 
	add_to_chat(167,msg)
end