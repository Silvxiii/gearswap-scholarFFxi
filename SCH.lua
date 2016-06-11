-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
        Custom commands:64

        Shorthand versions for each strategem type that uses the version appropriate for
        the current Arts.
		In-game macro: /console gs c scholar xxx

                                        Light Arts              Dark Arts

        gs c scholar light              Light Arts/Addendum
        gs c scholar dark                                       Dark Arts/Addendum
        gs c scholar cost               Penury                  Parsimony
        gs c scholar speed              Celerity                Alacrity
        gs c scholar aoe                Accession               Manifestation
        gs c scholar power              Rapture                 Ebullience
        gs c scholar duration           Perpetuance
        gs c scholar accuracy           Altruism                Focalization
        gs c scholar enmity             Tranquility             Equanimity
        gs c scholar skillchain                                 Immanence
        gs c scholar addendum           Addendum: White         Addendum: Black
--]]



-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
	include('organizer-lib')
	include('caster_buffWatcher.lua')
	buffWatcher.watchList = {
						["Aquaveil"]="Aquaveil",
                        ["Aquaveil"]="Aquaveil",
                        ["Haste"]="Haste",
                        ["Stoneskin"]="Stoneskin",
                        ["Phalanx"]="Phalanx",
                        ["Protect"]="Protect V",
                        ["Shell"]="Shell V",
						["Blink"]="Blink",
                        }
    include('SCH_helix_timer.lua')
	include('common_info.skillchain.lua')
	include('SCH_soloSC.lua')
	include('common_info.status.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	

    info.addendumNukes = S{"Stone IV", "Water IV", "Aero IV", "Fire IV", "Blizzard IV", "Thunder IV",
        "Stone V", "Water V", "Aero V", "Fire V", "Blizzard V", "Thunder V"}

    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
	update_active_strategems()
    
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')

    state.MagicBurst = M(false, 'Magic Burst')
	
	info.Helix = S{"Geohelix","Hydrohelix","Anemohelix","Pyrohelix","Cryohelix","Ionohelix","Luminohelix","Noctohelix",
                  "Geohelix II","Hydrohelix II","Anemohelix II","Pyrohelix II","Cryohelix II","Ionohelix II","Luminohelix II","Noctohelix II"}
	
    info.low_nukes = S{"Stone", "Water", "Aero", "Fire", "Blizzard", "Thunder", 
	                   "Stone II", "Water II", "Aero II", "Fire II", "Blizzard II", "Thunder II"}
    info.mid_nukes = S{}
	
    info.high_nukes = S{"Stone III", "Water III", "Aero III", "Fire III", "Blizzard III", "Thunder III",
					    "Stone IV", "Water IV", "Aero IV", "Fire IV", "Blizzard IV", "Thunder IV",
	                    "Stone V", "Water V", "Aero V", "Fire V", "Blizzard V", "Thunder V"}

    send_command('bind ` input /ma Stun <t>; wait 0.5; input /p Casting STUN on <t>.')
	send_command('bind ^` gs c toggle MagicBurst')
	send_command('bind !` input /ma Drain <me>')
	send_command('bind ^- gs c scholar light')
	send_command('bind ^= gs c scholar dark')
	send_command('bind delete gs c scholar speed')
	send_command('bind Home gs c scholar duration')-- sleep en darks arts
	send_command('bind End gs c scholar aoe')
    send_command('bind !- input /ja "Sublimation" <me>; wait 0.5; input /echo Subli mation ')
	send_command('bind != input /ma "Distract" <t>')
    select_default_macro_book()
end
function file_unload()
    if binds_on_unload then
        binds_on_unload()
    end
end
function user_unload()
	send_command('unbind `')
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind ^-')
	send_command('unbind ^=')
	send_command('unbind !-')
	send_command('unbind !=')
	send_command('unbind delete')
	send_command('unbind end')
	send_command('unbind home')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Start defining the sets
	--------------------------------------

	-- Precast Sets

	-- Precast sets to enhance JAs

	sets.precast.JA['Tabula Rasa'] = {legs="Peda. Pants +1"}
	sets.precast.JA['Dark Arts'] = {body="Academic's Gown +1"}
	sets.precast.JA['Light Arts'] = {legs="Academic's Pants +1"}
	sets.precast.JA['Enlightenment'] = {body="Peda. Gown +1"}
	-- Fast cast sets for spells
	
	sets.lockstyle={
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Befouled Crown",
    body={ name="Witching Robe", augments={'MP+50','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Refresh"+1',}},
    hands="Arbatel Bracers +1",
    legs={ name="Lengo Pants", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Refresh"+1',}},
    feet="Regal Pumps +1",
    neck="Sanctity Necklace",
    waist="Fucho-no-Obi",
    left_ear="Etiolation Earring",
    right_ear="Loquac. Earring",
    left_ring="Karieyh Ring",
    right_ring="Sheltered Ring",
    back="Izdubar Mantle",
}

	sets.precast.FC={
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Impatiens",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+11','"Fast Cast"+6','CHR+9',}},
    body={ name="Merlinic Jubbah", augments={'"Fast Cast"+6','MND+5','"Mag.Atk.Bns."+10',}},
    hands={ name="Merlinic Dastanas", augments={'Attack+17','"Fast Cast"+6','INT+4','"Mag.Atk.Bns."+11',}},
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+9','"Fast Cast"+6','"Mag.Atk.Bns."+13',}},
    neck="Baetyl Pendant",
    waist="Witful Belt",
    left_ear="Enchntr. Earring +1",
    right_ear="Loquac. Earring",
    left_ring="Rahab Ring",
    right_ring="Lebeche Ring",
    back="Perimede Cape",
}
sets.precast.FC.Storm ={
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Strobilus",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+11','"Fast Cast"+6','CHR+9',}},
    body={ name="Merlinic Jubbah", augments={'"Fast Cast"+6','MND+5','"Mag.Atk.Bns."+10',}},
    hands={ name="Merlinic Dastanas", augments={'Attack+17','"Fast Cast"+6','INT+4','"Mag.Atk.Bns."+11',}},
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+9','"Fast Cast"+6','"Mag.Atk.Bns."+13',}},
    neck="Baetyl Pendant",
    waist="Cascade Belt",
    left_ear="Enchntr. Earring +1",
    right_ear="Loquac. Earring",
    left_ring="Rahab Ring",
    right_ring="Etana Ring",
    back={ name="Bookworm's Cape", augments={'INT+5','MND+4','Helix eff. dur. +19',}},
}

	sets.precast.FC.Cure={
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Impatiens",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+11','"Fast Cast"+6','CHR+9',}},
    body={ name="Merlinic Jubbah", augments={'"Fast Cast"+6','MND+5','"Mag.Atk.Bns."+10',}},
    hands={ name="Telchine Gloves", augments={'Mag. Acc.+13 "Mag.Atk.Bns."+13','"Cure" potency +7%','Enh. Mag. eff. dur. +8',}},
    legs="Doyen Pants",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Baetyl Pendant",
    waist="Witful Belt",
    left_ear="Enchntr. Earring +1",
    right_ear="Mendi. Earring",
    left_ring="Rahab Ring",
    right_ring="Lebeche Ring",
    back="Pahtli Cape",
}

	sets.precast.FC.Curaga = sets.precast.FC.Cure
	
	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], { waist="Gishdubar Sash",feet="Inspirited Boots"})

	sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {neck="Baetyl Pendant"})

	sets.precast.FC.Impact = set_combine(sets.precast.FC['Elemental Magic'], {head=empty,body="Twilight Cloak"})
	
	sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], { head="Umuthi Hat", neck="Nodens Gorget",hands="Carapacho Cuffs"})
	
	-- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
	sets.precast.WS['Myrkr']={
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Strobilus",
    head={ name="Amalric Coif", augments={'MP+60','INT+10','Enmity-5',}},
    body={ name="Amalric Doublet", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    hands={ name="Peda. Bracers +1", augments={'Enh. "Tranquility" and "Equanimity"',}},
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet="Arbatel Loafers +1",
    neck="Sanctity Necklace",
    waist="Yamabuki-no-Obi",
    left_ear="Etiolation Earring",
    right_ear="Mendi. Earring",
    left_ring="Etana Ring",
    right_ring="Sangoma Ring",
    back="Pahtli Cape",
}


	-- Midcast Sets

	sets.midcast.FastRecast={
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Strobilus",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+11','"Fast Cast"+6','CHR+9',}},
    body={ name="Merlinic Jubbah", augments={'"Fast Cast"+6','MND+5','"Mag.Atk.Bns."+10',}},
    hands={ name="Merlinic Dastanas", augments={'"Occult Acumen"+8','INT+10','Mag. Acc.+15',}},
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','"Occult Acumen"+11','INT+4','Mag. Acc.+5','"Mag.Atk.Bns."+13',}},
    neck="Baetyl Pendant",
    waist="Cetl Belt",
    left_ear="Etiolation Earring",
    right_ear="Mendi. Earring",
    left_ring="Fenrir Ring +1",
    right_ring="Fenrir Ring +1",
    back="Perimede Cape",
}


	-- Cure Sets
	
	sets.midcast.Cure = {
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Impatiens",
    head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
    body={ name="Peda. Gown +1", augments={'Enhances "Enlightenment" effect',}},
    hands={ name="Telchine Gloves", augments={'Mag. Acc.+13 "Mag.Atk.Bns."+13','"Cure" potency +7%','Enh. Mag. eff. dur. +8',}},
    legs="Gyve Trousers",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Nodens Gorget",
    waist="Witful Belt",
    left_ear="Etiolation Earring",
    right_ear="Mendi. Earring",
    left_ring="Haoma's ring",
    right_ring="Sirona's Ring",
    back="Solemnity Cape",
}


	sets.midcast.CureWithLightWeather = set_combine(sets.midcast.Cure, {
    waist="Hachirin-no-Obi",})
	
    sets.self_healing = {neck="Phalaina Locket",waist="Gishdubar Sash",ring2="Kunaji Ring"}
 
	sets.midcast.Curaga = sets.midcast.Cure

	sets.midcast.Regen={
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Strobilus",
    head="Arbatel Bonnet +1",
    body={ name="Telchine Chas.", augments={'Evasion+19','"Cure" potency +4%','Enh. Mag. eff. dur. +8',}},
    hands={ name="Telchine Gloves", augments={'Mag. Acc.+13 "Mag.Atk.Bns."+13','"Cure" potency +7%','Enh. Mag. eff. dur. +8',}},
    legs={ name="Telchine Braconi", augments={'Evasion+18','"Fast Cast"+5','Enh. Mag. eff. dur. +8',}},
    feet={ name="Telchine Pigaches", augments={'Accuracy+15 Attack+15','"Fast Cast"+4','Enh. Mag. eff. dur. +9',}},
    neck="Sanctity Necklace",
    waist="Yamabuki-no-Obi",
    left_ear="Etiolation Earring",
    right_ear="Loquac. Earring",
    left_ring="Rahab Ring",
    right_ring="Sangoma Ring",
    back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},
}

    sets.Refresh={
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head={ name="Amalric Coif", augments={'INT+10','Elem. magic skill +15','Dark magic skill +15',}},
    body={ name="Witching Robe", augments={'MP+50','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Refresh"+1',}},
    hands={ name="Peda. Bracers +1", augments={'Enh. "Tranquility" and "Equanimity"',}},
    legs={ name="Lengo Pants", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Refresh"+1',}},
    feet="Inspirited Boots",
    neck="Incanter's Torque",
    waist="Gishdubar Sash",
    left_ear="Etiolation Earring",
    right_ear="Loquac. Earring",
    left_ring="Karieyh Ring",
    right_ring="Sheltered Ring",
    back="Perimede Cape",
}	
	-- Enhancing Magic Sets
	
	sets.midcast['Enhancing Magic']={
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
	head={ name="Telchine Cap", augments={'Mag. Evasion+25','"Conserve MP"+3','Enh. Mag. eff. dur. +10',}},
    body={ name="Telchine Chas.", augments={'Evasion+19','"Cure" potency +4%','Enh. Mag. eff. dur. +8',}},
    hands={ name="Telchine Gloves", augments={'Mag. Acc.+13 "Mag.Atk.Bns."+13','"Cure" potency +7%','Enh. Mag. eff. dur. +8',}},
    legs={ name="Telchine Braconi", augments={'Evasion+18','"Fast Cast"+5','Enh. Mag. eff. dur. +8',}},
    feet={ name="Telchine Pigaches", augments={'Accuracy+15 Attack+15','"Fast Cast"+4','Enh. Mag. eff. dur. +9',}},
    neck="Incanter's Torque",
    waist="Cascade Belt",
    left_ear="Digni. Earring",
    right_ear="Augment. Earring",
    left_ring="Etana Ring",
    right_ring="Sangoma Ring",
    back="Perimede Cape",
}

	sets.midcast.Cursna = {
		neck="Incanter's Torque",ring1="Haoma's Ring",ring2="Sirona's Ring",waist="Gishdubar Sash",}

	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {neck="Nodens Gorget",waist="Siegel Sash",legs="Doyen Pants"})

	sets.midcast.Storm = set_combine(sets.midcast['Enhancing Magic'], {feet="Peda. Loafers +1"})

	sets.midcast.Protect = {ring1="Sheltered Ring"}
	sets.midcast.Protectra = sets.midcast.Protect
	sets.midcast.Shell = {ring1="Sheltered Ring"}
	sets.midcast.Shellra = sets.midcast.Shell
	sets.midcast.Haste = sets.midcast['Enhancing Magic']
	sets.midcast.Erase = sets.midcast.FastRecast


	-- Custom spell classes
	sets.midcast['Enfeebling Magic']={
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Befouled Crown",
    body={ name="Vanya Robe", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}},
    hands={ name="Peda. Bracers +1", augments={'Enh. "Tranquility" and "Equanimity"',}},
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Medium's Sabots", augments={'MP+25','"Conserve MP"+2',}},
    neck="Incanter's Torque",
    waist="Casso Sash",
    left_ear="Barkaro. Earring",
    right_ear="Digni. Earring",
    left_ring="Globidonta Ring",
    right_ring="Sangoma Ring",
    back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},
}

	
	
	sets.midcast.Kaustra ={
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Pixie Hairpin +1",
    body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Mag. crit. hit dmg. +6%','INT+12','"Mag.Atk.Bns."+11',}},
    hands={ name="Chironic Gloves", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','INT+9','Mag. Acc.+10','"Mag.Atk.Bns."+11',}},
    legs={ name="Peda. Pants +1", augments={'Enhances "Tabula Rasa" effect',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','"Occult Acumen"+11','INT+4','Mag. Acc.+5','"Mag.Atk.Bns."+13',}},
    neck="Incanter's Torque",
    waist="Casso Sash",
    left_ear="Barkaro. Earring",
    right_ear="Dark Earring",
    left_ring="Archon Ring",
    right_ring="Shiva Ring +1",
    back="Lugh's Cape",
}

	sets.midcast['Dark Magic'] = {
    main="Akademos",
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head={ name="Amalric Coif", augments={'INT+10','Elem. magic skill +15','Dark magic skill +15',}},
    body="Psycloth Vest",
    hands="Amalric Gages",
    legs="Peda. Pants +1",
    feet="Arbatel Loafers +1",
    neck="Incanter's Torque",
    waist="Casso Sash",
    left_ear="Strophadic Earring",
    right_ear="Barkaro. Earring",
    left_ring="Archon Ring",
    right_ring="Evanescence Ring",
    back="BookWorm's Cape",
}

	sets.midcast.Drain ={
    main="Akademos",
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Striga Crown",
    body="Psycloth Vest",
    hands="Amalric Gages",
    legs="Peda. Pants +1",
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','"Occult Acumen"+11','INT+4','Mag. Acc.+5','"Mag.Atk.Bns."+13',}},
    neck="Incanter's Torque",
    waist="Fucho-no-Obi",
    left_ear="Barkarole earring",
    right_ear="Gwati Earring",
    left_ring="Archon Ring",
    right_ring="Evanescence Ring",
    back="BookWorm's Cape",
}

    sets.midcast.Klimaform={
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head={ name="Amalric Coif", augments={'INT+10','Elem. magic skill +15','Dark magic skill +15',}},
    body={ name="Psycloth Vest", augments={'Mag. Acc.+10','Spell interruption rate down +15%','MND+7',}},
    hands={ name="Merlinic Dastanas", augments={'"Occult Acumen"+8','INT+10','Mag. Acc.+15',}},
    legs={ name="Peda. Pants +1", augments={'Enhances "Tabula Rasa" effect',}},
    feet="Arbatel Loafers +1",
    neck="Incanter's Torque",
    waist="Casso Sash",
    left_ear="Dark Earring",
    right_ear="Barkaro. Earring",
    left_ring="Archon Ring",
    right_ring="Evanescence Ring",
    back={ name="Bookworm's Cape", augments={'INT+5','MND+4','Helix eff. dur. +19',}},
}
	
	sets.midcast.Aspir = sets.midcast.Drain

	sets.midcast.Stun={
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head={ name="Amalric Coif", augments={'INT+10','Elem. magic skill +15','Dark magic skill +15',}},
    body={ name="Merlinic Jubbah", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Magic burst mdg.+8%','INT+6','Mag. Acc.+13','"Mag.Atk.Bns."+15',}},
    hands={ name="Chironic Gloves", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','INT+9','Mag. Acc.+10','"Mag.Atk.Bns."+11',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','Magic Damage +13','INT+10','"Mag.Atk.Bns."+11',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','"Occult Acumen"+11','INT+4','Mag. Acc.+5','"Mag.Atk.Bns."+13',}},
    neck="Incanter's Torque",
    waist="Casso Sash",
    left_ear="Digni. Earring",
    right_ear="Barkaro. Earring",
    left_ring="Fenrir Ring +1",
    right_ring="Fenrir Ring +1",
    back={ name="Bookworm's Cape", augments={'INT+5','MND+4','Helix eff. dur. +19',}},
}
	sets.midcast.Stun.Resistant = set_combine(sets.midcast.Stun, {})


	 --Elemental Magic sets are default for handling low-tier nukes.
	sets.midcast['Elemental Magic']={
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','"Conserve MP"+1','INT+6','Mag. Acc.+15','"Mag.Atk.Bns."+13',}},
    body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Mag. crit. hit dmg. +6%','INT+12','"Mag.Atk.Bns."+11',}},
    hands={ name="Chironic Gloves", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','INT+9','Mag. Acc.+10','"Mag.Atk.Bns."+11',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','Magic Damage +13','INT+10','"Mag.Atk.Bns."+11',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','"Occult Acumen"+11','INT+4','Mag. Acc.+5','"Mag.Atk.Bns."+13',}},
    neck="Saevus Pendant +1",
    waist="Yamabuki-no-Obi",
    left_ear="Barkaro. Earring",
    right_ear="Friomisi Earring",
    left_ring="Fenrir Ring +1",
    right_ring="Fenrir Ring +1",
    back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},
}

	sets.midcast['Elemental Magic'].Resistant =set_combine( sets.midcast['Elemental Magic'].HighTierNuke,{ neck="Sanctity Necklace"})

	-- Custom refinements for certain nuke tiers
	sets.midcast['Elemental Magic'].HighTierNuke={
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','"Conserve MP"+1','INT+6','Mag. Acc.+15','"Mag.Atk.Bns."+13',}},
    body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Mag. crit. hit dmg. +6%','INT+12','"Mag.Atk.Bns."+11',}},
    hands={ name="Chironic Gloves", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','INT+9','Mag. Acc.+10','"Mag.Atk.Bns."+11',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','Magic Damage +13','INT+10','"Mag.Atk.Bns."+11',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','"Occult Acumen"+11','INT+4','Mag. Acc.+5','"Mag.Atk.Bns."+13',}},
    neck="Mizu. Kubikazari",
    waist="Yamabuki-no-Obi",
    left_ear="Barkaro. Earring",
    right_ear="Friomisi Earring",
    left_ring="Shiva Ring +1",
    right_ring="Shiva Ring +1",
    back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},
}
	sets.midcast.Impact = 
	{ 
	  main="Akademos",
    sub="Niobid Strap",
    ammo="Seraphic Ampulla",
	head=empty,
    body="Twilight Cloak",
    hands={ name="Merlinic Dastanas", augments={'"Occult Acumen"+8','INT+10','Mag. Acc.+15',}},
    legs="Perdition Slops",
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','"Occult Acumen"+11','INT+4','Mag. Acc.+5','"Mag.Atk.Bns."+13',}},
    neck="Combatant's Torque",
    waist="Oneiros Rope",
    left_ear="Dedition Earring",
    right_ear="Digni. Earring",
    left_ring="Petrov Ring",
    right_ring="Rajas Ring",
    back="Izdubar Mantle",
	}
		
	sets.midcast.Helix={
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head={ name="Amalric Coif", augments={'INT+10','Elem. magic skill +15','Dark magic skill +15',}},
    body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Mag. crit. hit dmg. +6%','INT+12','"Mag.Atk.Bns."+11',}},
    hands={ name="Chironic Gloves", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','INT+9','Mag. Acc.+10','"Mag.Atk.Bns."+11',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst mdg.+11%','INT+4',}},
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic burst mdg.+9%','INT+7','Mag. Acc.+4','"Mag.Atk.Bns."+12',}},
    neck="Incanter's Torque",
    waist="Yamabuki-no-Obi",
    left_ear="Digni. Earring",
    right_ear="Barkaro. Earring",
    left_ring="Shiva Ring +1",
    right_ring="Shiva Ring +1",
    back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},
}
	sets.midcast.Noctohelix = set_combine(sets.midcast.Helix, {head="Pixie Hairpin +1"})


	-- Sets to return to when not performing an action.

	-- Resting sets
	sets.resting = {
    main="Akademos",
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Befouled Crown",
    body="Witching Robe",
    hands="Arbatel Bracers +1",
    legs="Arbatel Pants +1",
    feet="Regal Pumps +1",
    neck="Sanctity Necklace",
    waist="Fucho-no-Obi",
    left_ear="Etiolation Earring",
    right_ear="Loquac. Earring",
    left_ring="Karieyh Ring",
    right_ring="Sheltered Ring",
    back="Izdubar Mantle",
}


	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

	sets.idle.Town ={
    main="Akademos",
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Arbatel Bonnet +1",
    body="Witching Robe",
    hands="Arbatel Bracers +1",
    legs="Arbatel Pants +1",
    feet="Peda. Loafers +1",
    neck="Sanctity Necklace",
    waist="Fucho-no-Obi",
    left_ear="Etiolation Earring", 
    right_ear="Loquac. Earring",
    left_ring="Karieyh Ring",
    right_ring="Sheltered Ring",
     back="Lugh's Cape",
}

	sets.idle.Field ={
    main="Akademos",
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Befouled Crown",
    body="Witching Robe",
    hands="Arbatel Bracers +1",
    legs="Lengo Pants",
    feet="Regal Pumps +1",
    neck="Sanctity Necklace",
    waist="Fucho-no-Obi",
    left_ear="Etiolation Earring", 
    right_ear="Loquac. Earring",
    left_ring="Karieyh Ring",
    right_ring="Sheltered Ring",
    back="Izdubar Mantle",
}	

	sets.idle.Weak = sets.idle.Field
	
	-- Defense sets

	sets.defense.PDT = {
	main="Akademos",
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Arbatel Bonnet +1",
    body="Arbatel Gown +1",
    hands="Chironic Gloves",
    legs="Gyve Trousers",
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','"Occult Acumen"+11','INT+4','Mag. Acc.+5','"Mag.Atk.Bns."+13',}},
    neck="Loricate Torque +1",
    waist="Gishdubar Sash",
    left_ear="Etiolation Earring", 
    right_ear="Infused Earring",
    left_ring="Patricius Ring",
    right_ring="Defending Ring",
    back="Solemnity Cape"
}

	sets.defense.MDT = {
    main="Akademos",
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Arbatel Bonnet +1",
    body="Arbatel Gown +1",
    hands="Chironic Gloves",
    legs="Gyve Trousers",
    feet={ name="Merlinic Crackows", augments={'Mag. Acc.+21 "Mag.Atk.Bns."+21','"Occult Acumen"+11','INT+4','Mag. Acc.+5','"Mag.Atk.Bns."+13',}},
    neck="Loricate Torque +1",
    waist="Gishdubar Sash",
    left_ear="Etiolation Earring", 
    right_ear="Infused Earring",
    left_ring="Archon Ring",
    right_ring="Defending Ring",body={ name="Merlinic Jubbah", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Magic burst mdg.+8%','INT+6','Mag. Acc.+13','"Mag.Atk.Bns."+15',}},
    legs="Merlinic Shalwar",
    back="Solemnity Cape",
}

	sets.Kiting = {feet="Herald's Gaiters"}

	sets.latent_refresh = { body="Witching Robe",legs="Lengo Pants",waist="Fucho-No-Obi"}

	-- Engaged sets

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- Normal melee group
	sets.engaged ={
    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Pemphredo Tathlum",
    head="Befouled Crown",
    body={ name="Witching Robe", augments={'MP+50','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Refresh"+1',}},
    hands={ name="Chironic Gloves", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','INT+9','Mag. Acc.+10','"Mag.Atk.Bns."+11',}},
    legs={ name="Lengo Pants", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Refresh"+1',}},
    feet={ name="Telchine Pigaches", augments={'Accuracy+15 Attack+15','"Fast Cast"+4','Enh. Mag. eff. dur. +9',}},
    neck="Combatant's Torque",
    waist="Eschan Stone",
    left_ear="Etiolation Earring",
    right_ear="Digni. Earring",
    left_ring="Petrov Ring",
    right_ring="Rajas Ring",
    back="Relucent Cape",
}



	-- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
	sets.buff['Ebullience'] = {head="Arbatel Bonnet +1"}
	sets.buff['Rapture'] = {head="Arbatel Bonnet +1"}
	sets.buff['Perpetuance'] = {hands="Arbatel Bracers +1"}
	sets.buff['Immanence'] = {hands="Arbatel Bracers +1"}
	sets.buff['Penury'] = {legs="Arbatel Pants +1"}
	sets.buff['Parsimony'] = {legs="Arbatel Pants +1"}
	sets.buff['Celerity'] = {feet="Pedagogy Loafers +1"}
	sets.buff['Alacrity'] = {feet="Pedagogy Loafers +1"}
	sets.buff['Stormsurge'] = {feet="Pedagogy Loafers +1"}
	sets.buff['Klimaform'] = {feet="Arbatel Loafers +1"}

	sets.buff.FullSublimation = { head="Acad. Mortar. +1",ear1="Savant's Earring",body="Pedagogy Gown +1"}
	sets.buff.PDTSublimation = { head="Acad. Mortar. +1",ear1="Savant's Earring",body="Pedagogy Gown +1"}
	
	sets.magic_burst =set_combine( sets.midcast['Elemental Magic'].HighTierNuke, 
	{neck="Mizu. Kubikazari",hands="Amalric Gages",
   -- body={ name="Merlinic Jubbah", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Magic burst mdg.+8%','INT+6','Mag. Acc.+13','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst mdg.+11%','INT+4',}},
	feet={ name="Merlinic Crackows", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic burst mdg.+9%','INT+7','Mag. Acc.+4','"Mag.Atk.Bns."+12',}},
    back="Lugh's Cape",ring2="Mujin Band"})

	
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
function job_precast(spell, action, spellMap, eventArgs)
    refine_various_spells(spell, action, spellMap, eventArgs)
	
	if spell.english == 'Sneak' and buffactive.sneak then
        send_command('@wait 1;cancel 71;')
    end
	
end

function job_buff_change(buff, gain)
  for index,value in pairs(buffWatcher.watchList) do
    if index==buff then
      buffWatch()
    end
  end
end
-------------------------------------Aspir,Sleep/ga Nuke's refine rules (thanks Asura.Vafruvant for this code)-----------------------------------
function refine_various_spells(spell, action, spellMap, eventArgs)
    aspirs = S{'Aspir','Aspir II'}
    sleeps = S{'Sleep','Sleep II'}
 
	nukes = S{'Fire', 'Blizzard', 'Aero', 'Stone', 'Thunder', 'Water',
        'Fire II', 'Blizzard II', 'Aero II', 'Stone II', 'Thunder II', 'Water II',
        'Fire III', 'Blizzard III', 'Aero III', 'Stone III', 'Thunder III', 'Water III',
        'Fire IV', 'Blizzard IV', 'Aero IV', 'Stone IV', 'Thunder IV', 'Water IV',
        'Fire V', 'Blizzard V', 'Aero V', 'Stone V', 'Thunder V', 'Water V',
        
        
		}
 
    if not  sleeps:contains(spell.english) and not aspirs:contains(spell.english) and not nukes:contains(spell.english)then
        return
    end
 
    local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local cancelling = 'All '..spell.english..' spells are on cooldown. Cancelling spell casting.'
  
    if spell_recasts[spell.recast_id] > 0 then
        if aspirs:contains(spell.english) then
            if spell.english == 'Aspir' then
                add_to_chat(122,cancelling)
                eventArgs.cancel = true
                return
            elseif spell.english == 'Aspir II' then
                newSpell = 'Aspir'
            
            end         
        elseif sleeps:contains(spell.english) then
            if spell.english == 'Sleep' then
                add_to_chat(122,cancelling)
                eventArgs.cancel = true
                return
            elseif spell.english == 'Sleep II' then
                newSpell = 'Sleep'
            end
       
		elseif nukes:contains(spell.english) then	
			if spell.english == 'Fire' then
			   eventArgs.cancel = true
                return
            elseif spell.english == 'Fire V' then
                newSpell = 'Fire IV'
			elseif spell.english == 'Fire IV' then
                newSpell = 'Fire III'	
			elseif spell.english == 'Fire III' then
                newSpell = 'Fire II'
			elseif spell.english == 'Fire II' then
                newSpell = 'Fire'
            end    			
			if spell.english == 'Blizzard' then
			   eventArgs.cancel = true
                return
			elseif spell.english == 'Blizzard V' then
                newSpell = 'Blizzard IV'
			elseif spell.english == 'Blizzard IV' then
                newSpell = 'Blizzard III'	
			elseif spell.english == 'Blizzard III' then 
                newSpell = 'Blizzard II'
			elseif spell.english == 'Blizzard II' then 
                newSpell = 'Blizzard'	
			end  
			if spell.english == 'Aero' then
			   eventArgs.cancel = true
                return
			elseif spell.english == 'Aero V' then
                newSpell = 'Aero IV'
			elseif spell.english == 'Aero IV' then 
                newSpell = 'Aero III'	
			elseif spell.english == 'Aero III' then
                newSpell = 'Aero II'
			elseif spell.english == 'Aero II' then
                newSpell = 'Aero'
			end  	
			if spell.english == 'Stone' then
			   eventArgs.cancel = true
                return
			elseif spell.english == 'Stone V' then
                newSpell = 'Stone IV'
			elseif spell.english == 'Stone IV' then
                newSpell = 'Stone III'	
			elseif spell.english == 'Stone III' then
                newSpell = 'Stone II'
			elseif spell.english == 'Stone II' then
                newSpell = 'Stone'	
			end  
			if spell.english == 'Thunder' then
			   eventArgs.cancel = true
                return
			elseif spell.english == 'Thunder V' then
                newSpell = 'Thunder IV'
			elseif spell.english == 'Thunder IV' then
                newSpell = 'Thunder III'	
			elseif spell.english == 'Thunder III' then
                newSpell = 'Thunder II'
			elseif spell.english == 'Thunder II' then
                newSpell = 'Thunder'
			end  
			if spell.english == 'Water' then
			   eventArgs.cancel = true
                return
			elseif spell.english == 'Water V' then
                newSpell = 'Water IV'
			elseif spell.english == 'Water IV' then
                newSpell = 'Water III'	
			elseif spell.english == 'Water III' then
                newSpell = 'Water II'
			elseif spell.english == 'Water II' then
                newSpell = 'Water'
			end  
        end
    end
  
    if newSpell ~= spell.english then
        send_command('@input /ma "'..newSpell..'" '..tostring(spell.target.raw))
        eventArgs.cancel = true
        return
    end
end
function job_precast(spell, action, spellMap, eventArgs)
    refine_various_spells(spell, action, spellMap, eventArgs)
	
	if spell.english == 'Sneak' and buffactive.sneak then
        send_command('@wait 1;cancel 71;')
    end
	buffWatcher.casting = true
	
end

-- Run after the general midcast() is done.
function job_post_midcast(spell, action, spellMap, eventArgs)

     if spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.self_healing)
    end
    if spell.action_type == 'Magic' then
        apply_grimoire_bonuses(spell, action, spellMap, eventArgs)
    end
	if spell.skill == 'Elemental Magic'  then
        if spell.element == world.day_element or spell.element == world.weather_element then
            equip({waist="Hachirin-No-Obi"})
            add_to_chat(8,'----- Obi Equipped. -----')
        end
    end
	if spell.skill == 'Elemental Magic' then
        if state.MagicBurst.value then
        equip(sets.magic_burst)
        end
	end
end

function job_aftercast(spell)  
    if spell.english == 'Sleep' then
        send_command('@wait 50;input /echo ------- '..spell.english..' is wearing off in 10 seconds -------')
    elseif spell.english == 'Sleep II' or spell.english == 'Sleepga II' then
        send_command('@wait 80;input /echo ------- '..spell.english..' is wearing off in 10 seconds -------')
    elseif spell.english == 'Break' or spell.english == 'Breakga' then
        send_command('@wait 20;input /echo ------- '..spell.english..' is wearing off in 10 seconds -------')
    end
 if spell.english == 'Sleep II' then
    send_command('timers c "Sleep II" 90 down spells/00259.png')
  elseif spell.english == 'Sleep' then
    send_command('timers c "Sleep" 60 down spells/00253.png')
  elseif spell.english == 'Break' then
    send_command('timers c "Break" 30 down spells/00255.png')
  end
	buffWatcher.casting = false

end
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
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if buff == "Sublimation: Activated" then
        handle_equipping_gear(player.status)
    end
	 for index,value in pairs(buffWatcher.watchList) do
    if index==buff then
      buffWatch()
    end
  end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','range')
        else
            enable('main','sub','range')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
		
            if world.weather_element == 'Light' then
                return 'CureWithLightWeather'
            end
        elseif spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Elemental Magic' then
            if info.low_nukes:contains(spell.english) then
                return 'LowTierNuke'
            elseif info.mid_nukes:contains(spell.english) then
                return 'MidTierNuke'
            elseif info.high_nukes:contains(spell.english) then
                return 'HighTierNuke'
            end
        end
    end
end

function customize_idle_set(idleSet)
    if state.Buff['Sublimation: Activated'] then
        if state.IdleMode.value == 'Normal' then
            idleSet = set_combine(idleSet, sets.buff.FullSublimation)
        elseif state.IdleMode.value == 'PDT' then
            idleSet = set_combine(idleSet, sets.buff.PDTSublimation)
        end
    end

    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end

    return idleSet
end


-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    if cmdParams[1] == 'user' and not (buffactive['light arts']      or buffactive['dark arts'] or
                       buffactive['addendum: white'] or buffactive['addendum: black']) then
        if state.IdleMode.value == 'Stun' then
            send_command('@input /ja "Dark Arts" <me>')
        else
            send_command('@input /ja "Light Arts" <me>')
        end
    end

    update_active_strategems()
    update_sublimation()
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'soloSC' then
    if not cmdParams[2] or not cmdParams[3] then
      errlog('missing required parameters for function soloSkillchain')
      return
    else
      soloSkillchain(cmdParams[2],cmdParams[3],cmdParams[4])
    end
end
	  
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    end
	-- maybe some other stuff
  if cmdParams[1] == 'buffWatcher' then
	  buffWatch(cmdParams[2],cmdParams[3])
  end
  if cmdParams[1] == 'stopBuffWatcher' then
	  stopBuffWatcher()
  end
-- maybe some other stuff
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job. 
-------------------------------------------------------------------------------------------------------------------
-- Reset the state vars tracking strategems.5
-- Reset the state vars tracking strategems.
function update_active_strategems()
    state.Buff['Ebullience'] = buffactive['Ebullience'] or false
    state.Buff['Rapture'] = buffactive['Rapture'] or false
    state.Buff['Perpetuance'] = buffactive['Perpetuance'] or false
    state.Buff['Immanence'] = buffactive['Immanence'] or false
    state.Buff['Penury'] = buffactive['Penury'] or false
    state.Buff['Parsimony'] = buffactive['Parsimony'] or false
    state.Buff['Celerity'] = buffactive['Celerity'] or false
    state.Buff['Alacrity'] = buffactive['Alacrity'] or false

    state.Buff['Klimaform'] = buffactive['Klimaform'] or false
end

function update_sublimation()
    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
	
end

-- Equip sets appropriate to the active buffs, relative to the spell being cast.
function apply_grimoire_bonuses(spell, action, spellMap)
    if buffactive.perpetuance and spell.type =='WhiteMagic' and spell.skill == 'Enhancing Magic' then
        equip(sets.buff.Perpetuance)
    end
    if  buffactive.Rapture and (spellMap == 'Cure' or spellMap == 'Curaga') then
        equip(state.Buff.Rapture)
    end
    if spell.skill == 'Elemental Magic' or spellMap ~= 'ElementalEnfeeble' then
        if buffactive.Ebullience and spell.english ~= 'Impact' then
            equip(sets.buff.Ebullience)
        end
        if  buffactive.Immanence then
            equip(sets.buff.Immanence)
        end
        if buffactive.Klimaform and spell.element == world.weather_element then
            equip(sets.buff.Klimaform)
        end
    end 

    
    if buffactive.Penury then equip(sets.buff.Penury) end
    if buffactive.Parsimony then equip(sets.buff.Parsimony) end
    if buffactive.Celerity then equip(sets.buff.Celerity) end
    if buffactive.Alacrity then equip(sets.buff.Alacrity) end
end


function display_current_caster_state()
	local msg = ''

	if state.OffenseMode.value ~= 'None' then
		msg = msg .. 'Melee'

		if state.CombatForm.has_value then
			msg = msg .. ' (' .. state.CombatForm.value .. ')'
		end
        
		msg = msg .. ', '
	end

	msg = msg .. 'Idle ['..state.IdleMode.value..'], Casting ['..state.CastingMode.value..']'

	add_to_chat(122, msg)
	local currentStrats = get_current_strategem_count()
	local arts
	if buffactive['Light Arts'] or buffactive['Addendum: White'] then
		arts = 'Light Arts'
	elseif buffactive['Dark Arts'] or buffactive['Addendum: Black'] then
		arts = 'Dark Arts'
	else
		arts = 'No Arts Activated'
	end
	add_to_chat(122, 'Current Available Strategems: ['..currentStrats..'], '..arts..'')
end

-- General handling of strategems in an Arts-agnostic way.
-- Format: gs c scholar <strategem>
function handle_strategems(cmdParams)
    -- cmdParams[1] == 'scholar'
    -- cmdParams[2] == strategem to use
	if not cmdParams[2] then
		add_to_chat(123,'Error: No strategem command given.')
		return
	end

	local currentStrats = get_current_strategem_count()
	local newStratCount = currentStrats - 1
	local strategem = cmdParams[2]:lower()
	
	if currentStrats > 0 and strategem ~= 'light' and strategem ~= 'dark' then
		add_to_chat(122, '***Current Charges Available: ['..newStratCount..']***')
	elseif currentStrats == 0 then
		add_to_chat(122, '***Out of strategems! Canceling...***')
		return
	end

	if strategem == 'light' then
		if buffactive['light arts'] then
			send_command('input /ja "Addendum: White" <me>')
			add_to_chat(122, '***Current Charges Available: ['..newStratCount..']***')
		elseif buffactive['addendum: white'] then
			add_to_chat(122,'Error: Addendum: White is already active.')
		elseif buffactive['dark arts']  or buffactive['addendum: black'] then
			send_command('input /ja "Light Arts" <me>')
			add_to_chat(122, '***Changing Arts! Current Charges Available: ['..currentStrats..']***')
		else
			send_command('input /ja "Light Arts" <me>')
		end
	elseif strategem == 'dark' then
		if buffactive['dark arts'] then
			send_command('input /ja "Addendum: Black" <me>')
			add_to_chat(122, '***Current Charges Available: ['..newStratCount..']***')
        elseif buffactive['addendum: black'] then
			add_to_chat(122,'Error: Addendum: Black is already active.')
		elseif buffactive['light arts'] or buffactive['addendum: white'] then
			send_command('input /ja "Dark Arts" <me>')
			add_to_chat(122, '***Changing Arts! Current Charges Available: ['..currentStrats..']***')
		else
			send_command('input /ja "Dark Arts" <me>')
		end
	elseif buffactive['light arts'] or buffactive['addendum: white'] then 
		if strategem == 'cost' then 
			send_command('@input /ja Penury <me>')
		elseif strategem == 'speed' then
			send_command('@input /ja Celerity <me>')
		elseif strategem == 'aoe' then
			send_command('@input /ja Accession <me>')
		elseif strategem == 'power' then
			send_command('@input /ja Rapture <me>')
		elseif strategem == 'duration' then
			send_command('@input /ja Perpetuance <me>')
		elseif strategem == 'accuracy' then
			send_command('@input /ja Altruism <me>')
		elseif strategem == 'enmity' then
			send_command('@input /ja Tranquility <me>')
		elseif strategem == 'skillchain' then
			add_to_chat(122,'Error: Light Arts does not have a skillchain strategem.')
		elseif strategem == 'addendum' then
			send_command('@input /ja "Addendum: White" <me>')
		else
			add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
		end
	elseif buffactive['dark arts']  or buffactive['addendum: black'] then
		if strategem == 'cost' then
			send_command('@input /ja Parsimony <me>')
		elseif strategem == 'speed' then
			send_command('@input /ja Alacrity <me>')
		elseif strategem == 'aoe' then
			send_command('@input /ja Manifestation <me>')
		elseif strategem == 'power' then 
			send_command('@input /ja Ebullience <me>')
		elseif strategem == 'duration' then
			send_command('@input /ma "Sleep II" <t>')
		elseif strategem == 'accuracy' then
			send_command('@input /ja Focalization <me>')
		elseif strategem == 'enmity' then
			send_command('@input /ja Equanimity <me>')
		elseif strategem == 'skillchain' then
			send_command('@input /ja Immanence <me>')
		elseif strategem == 'addendum' then
			send_command('@input /ja "Addendum: Black" <me>')
			
		else
			add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
		end
	else
		add_to_chat(123,'No arts has been activated yet.')
	end
end

function get_current_strategem_count()
	local allRecasts = windower.ffxi.get_ability_recasts()
	local stratsRecast = allRecasts[231]

	local maxStrategems = math.floor(player.main_job_level + 10) / 20

	local fullRechargeTime = 5*33

	local currentCharges = math.floor(maxStrategems - maxStrategems * stratsRecast / fullRechargeTime)
	
	return currentCharges
end

function errlog(msg) 
	add_to_chat(167,msg)
	end
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    if player.sub_job == 'RDM' then
        set_macro_page(2, 10)
    elseif player.sub_job == 'BLM' then
        set_macro_page(2, 10)	
    elseif player.sub_job == 'WHM' then
        set_macro_page(2, 10)
	end	
end
