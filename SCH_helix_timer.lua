--[[
FILE : SCH.lua

* 1. Edit function user_setup by adding the following lines :
info.Helix = S{"Geohelix","Hydrohelix","Anemohelix","Pyrohelix","Cryohelix","Ionohelix","Luminohelix","Noctohelix",
                  "Geohelix II","Hydrohelix II","Anemohelix II","Pyrohelix II","Cryohelix II","Ionohelix II","Luminohelix II","Noctohelix II"}


* 2. Edit function job_setup by adding the following line :
include('SCH_helix_timer.lua')


* Add or edit function job_aftercast :

function job_aftercast(spell, action, spellMap, eventArgs)

-- helix timers
  if (not spell.interrupted) then
    if info.Helix:contains(spell.english) then
        createTimerHelix(spell.english)
    end  
    if (spell.english=='Modus Veritas' or spell.english=='Stone') then
      createTimerModusVeritas()
    end
  end -- end of helix timers 
  
end -- end of the function


FILE : HERE

* 3. Edit below the helix.bonus.jobPoints and helix.bonus.meritModusVeritas according to your character

* 4. Enjoy !
--]]

helix = {}
helix.bonus = {}
helix.bonus.jobPoints = 20 -- Job points spent in "Dark Arts Effect"
helix.bonus.meritModusVeritas = 5 -- Merit level of "Modus Veritas Duration"
helix.timeLanded = ''
helix.duration = 0
helix.name = ''
helix.icon = {}
helix.icon = {
['Geohelix II']='00885.png',['Hydrohelix II']='00886.png',['Amenohelix II']='00887.png',['Pyrohelix II']='00888.png',['Cryohelix II']='00889.png',['Ionohelix II']='00890.png',['Luminohelix II']='00892.png',['Noctohelix II']='00891.png',
['Geohelix']='00278.png',['Hydrohelix']='00279.png',['Amenohelix']='00280.png',['Pyrohelix']='00281.png',['Cryohelix']='00282.png',['Ionohelix']='00283.png',['Luminohelix']='00285.png',['Noctohelix']='00284.png'
}
function createTimerHelix(helixName)
  helix.timeLanded = os.clock()
  helix.duration = 90
  helix.name = helixName

  local cmd = 'timers c "'..helixName..'" '
  local darkArts = (buffactive["Dark Arts"] or buffactive["Addendum: Black"] or false)
  if darkArts then
    helix.duration = helix.duration + (helix.bonus.jobPoints*3) + 80
  end
  cmd = cmd ..tostring(helix.duration)..' down'
  if(helix.icon[helixName]~=nil) then 
    cmd = cmd..' spells/'..helix.icon[helixName]
  end
  send_command(cmd)
end


function createTimerModusVeritas()
  local now = os.clock()
  if(helix.timeLanded==0 or helix.duration==0) then return end
  local remaining =  helix.duration - (now-helix.timeLanded)
  if (remaining <= 0) then return end

   -- initially, the helix duration is reduced to 50%
   -- MV merit bonus gives + 10% duration, but for the remaining 50%. Which is equivalent to +5% of initial duration.
  local factor = 0.5 + (0.05 * helix.bonus.meritModusVeritas)
  local cmd = 'timers c "'..helix.name..' (MV)" '..tostring(remaining*factor)..' down'
  if(helix.icon[helix.name]~=nil) then 
    cmd = cmd..' spells/'..helix.icon[helix.name]
  end
  send_command(cmd)
  --helix.timeLanded = 0
  --helix.duration = 0
end