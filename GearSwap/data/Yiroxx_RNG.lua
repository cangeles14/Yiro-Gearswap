-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

	-- Load and initialize the include file.
	include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	state.Buff.Barrage = buffactive.Barrage or false
	state.Buff.Camouflage = buffactive.Camouflage or false
	state.Buff['Unlimited Shot'] = buffactive['Unlimited Shot'] or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'Acc')
	
	gear.default.weaponskill_neck = "Ocachi Gorget"
	gear.default.weaponskill_waist = "Elanid Belt"
	
	DefaultAmmo = {['Yoichinoyumi'] = "Achiyalabopa arrow", ['Annihilator'] = "Achiyalabopa bullet"}
	U_Shot_Ammo = {['Yoichinoyumi'] = "Achiyalabopa arrow", ['Annihilator'] = "Achiyalabopa bullet"}

	select_default_macro_book()

	send_command('bind f9 gs c cycle RangedMode')
	send_command('bind ^f9 gs c cycle OffenseMode')
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind f9')
	send_command('unbind ^f9')
end


-- Set up all gear sets.
function init_gear_sets()
	--------------------------------------
	-- Precast sets
	--------------------------------------

	-- Precast sets to enhance JAs
	sets.precast.JA['Bounty Shot'] = {hands="Sylvan Glovelettes +2"}
	sets.precast.JA['Camouflage'] = {body="Orion Jerkin +3"}
	sets.precast.JA['Scavenge'] = {feet="Orion Socks +2"}
	sets.precast.JA['Shadowbind'] = {hands="Orion Bracers +2"}
	sets.precast.JA['Sharpshot'] = {legs="Orion Braccae +2"}


	-- Fast cast sets for spells

	sets.precast.FC = {}

	sets.precast.FC.Utsusemi = {}


	-- Ranged sets (snapshot)
	
	sets.precast.RA = {
		head="Orion Beret +3",
		body="Amini Caban +1",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Pursuer's Pants", augments={'AGI+10','"Rapid Shot"+10','"Subtle Blow"+7',}},
		feet={ name="Arcadian Socks +3", augments={'Enhances "Stealth Shot" effect',}},
		neck="Scout's Gorget +2",
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Ilabrat Ring",
		back={ name="Belenus's Cape", augments={'"Snapshot"+10',}},
	}

-- feet={ name="Arcadian Socks +3", augments={'Enhances "Stealth Shot" effect',}}
--legs={ name="Pursuer's Pants", augments={'AGI+10','"Rapid Shot"+10','"Subtle Blow"+7',}}

	-- Weaponskill sets --
	
	sets.precast.WS['Trueflight'] = {
		head={ name="Herculean Helm", augments={'"Mag.Atk.Bns."+22','Weapon skill damage +4%','AGI+10','Mag. Acc.+14',}},
		body={ name="Herculean Vest", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','Weapon skill damage +4%','"Mag.Atk.Bns."+10',}},
		hands={ name="Herculean Gloves", augments={'Mag. Acc.+13 "Mag.Atk.Bns."+13','Weapon skill damage +4%','MND+5','"Mag.Atk.Bns."+15',}},
		legs={ name="Herculean Trousers", augments={'"Mag.Atk.Bns."+25','Weapon skill damage +4%','MND+4','Mag. Acc.+9',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Weapon skill damage +3%','STR+8','Mag. Acc.+12',}},
		neck="Scout's Gorget +2",
		waist="Eschan Stone",
		left_ear="Ishvara Earring",
		right_ear="Friomisi Earring",
		left_ring="Dingir Ring",
		right_ring="Weather. Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},
	}
	
	sets.precast.WS['Last Stand'] = {
		head="Orion Beret +3",
		body={ name="Herculean Vest", augments={'Rng.Acc.+17 Rng.Atk.+17','Weapon skill damage +4%','AGI+7','Rng.Acc.+15',}},
		hands="Meg. Gloves +2",
		legs={ name="Arc. Braccae +3", augments={'Enhances "Eagle Eye Shot" effect',}},
		feet={ name="Herculean Boots", augments={'Rng.Atk.+7','Weapon skill damage +4%','AGI+10','Rng.Acc.+11',}},
		neck="Scout's Gorget +2",
		waist="Fotia Belt",
		left_ear="Telos Earring",
		right_ear="Ishvara Earring",
		left_ring="Regal Ring",
		right_ring="Dingir Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},
	}

	sets.precast.WS.Acc = {}

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.


	--------------------------------------
	-- Midcast sets
	--------------------------------------

	-- Fast recast for spells
	
	sets.midcast.FastRecast = {}

	sets.midcast.Utsusemi = {}

	-- Ranged sets

	sets.midcast.RA = {
		head={ name="Arcadian Beret +3", augments={'Enhances "Recycle" effect',}},
		body="Orion Jerkin +3",
		hands={ name="Adhemar Wrist. +1", augments={'AGI+12','Rng.Acc.+20','Rng.Atk.+20',}},
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','Rng.Acc.+20','Rng.Atk.+20',}},
		feet={ name="Adhe. Gamashes +1", augments={'HP+65','"Store TP"+7','"Snapshot"+10',}},
		neck="Scout's Gorget +2",
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear="Enervating Earring",
		left_ring="Regal Ring",
		right_ring="Ilabrat Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Damage taken-5%',}},
	}
	
	sets.midcast.RA.Acc = {}

	sets.midcast.RA.Annihilator = {}

	sets.midcast.RA.Annihilator.Acc = {}

	sets.midcast.RA.Yoichinoyumi = {}

	sets.midcast.RA.Yoichinoyumi.Acc = {}
	
	--------------------------------------
	-- Idle/resting/defense/etc sets
	--------------------------------------

	-- Sets to return to when not performing an action.

	-- Resting sets
	sets.resting = {}

	-- Idle sets
	sets.idle = {}
	
	sets.idle.Town = {
		main={ name="Malevolence", augments={'INT+10','"Mag.Atk.Bns."+6',}},
		sub={ name="Malevolence", augments={'INT+6','Mag. Acc.+7','"Mag.Atk.Bns."+4','"Fast Cast"+3',}},
		range="Gastraphetes",
		ammo="Quelling Bolt",
		head={ name="Arcadian Beret +3", augments={'Enhances "Recycle" effect',}},
		body="Orion Jerkin +3",
		hands={ name="Adhemar Wrist. +1", augments={'AGI+12','Rng.Acc.+20','Rng.Atk.+20',}},
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','Rng.Acc.+20','Rng.Atk.+20',}},
		feet={ name="Adhe. Gamashes +1", augments={'HP+65','"Store TP"+7','"Snapshot"+10',}},
		neck="Scout's Gorget +2",
		waist="Yemaya Belt",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Ilabrat Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Damage taken-5%',}},
	}
	
	-- Defense sets
	sets.defense.PDT = {}

	sets.defense.MDT = {}

	sets.Kiting = {}


	--------------------------------------
	-- Engaged sets
	--------------------------------------

	sets.engaged = {
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body="Meg. Cuirie +2",
		hands={ name="Adhemar Wrist. +1", augments={'AGI+12','Rng.Acc.+20','Rng.Atk.+20',}},
		legs={ name="Samnuha Tights", augments={'STR+8','DEX+9','"Dbl.Atk."+3','"Triple Atk."+2',}},
		feet="Meg. Jam. +2",
		neck="Scout's Gorget +2",
		waist="Sarissapho. Belt",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring="Epona's Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Damage taken-5%',}},
	}

	sets.engaged.Acc = {}

	--------------------------------------
	-- Custom buff sets
	--------------------------------------

	sets.buff.Barrage = set_combine(sets.midcast.RA.Acc, {hands="Orion Bracers +2"})
	sets.buff.Camouflage = {body="Orion Jerkin +3"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' then
		state.CombatWeapon:set(player.equipment.range)
	end

	if spell.action_type == 'Ranged Attack' or
	  (spell.type == 'WeaponSkill' and (spell.skill == 'Marksmanship' or spell.skill == 'Archery')) then
		check_ammo(spell, action, spellMap, eventArgs)
	end
	
	if state.DefenseMode.value ~= 'None' and spell.type == 'WeaponSkill' then
		-- Don't gearswap for weaponskills when Defense is active.
		eventArgs.handled = true
	end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' and state.Buff.Barrage then
		equip(sets.buff.Barrage)
		eventArgs.handled = true
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if buff == "Camouflage" then
		if gain then
			equip(sets.buff.Camouflage)
			disable('body')
		else
			enable('body')
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Check for proper ammo when shooting or weaponskilling
function check_ammo(spell, action, spellMap, eventArgs)
	-- Filter ammo checks depending on Unlimited Shot
	if state.Buff['Unlimited Shot'] then
		if player.equipment.ammo ~= U_Shot_Ammo[player.equipment.range] then
			if player.inventory[U_Shot_Ammo[player.equipment.range]] or player.wardrobe[U_Shot_Ammo[player.equipment.range]] then
				add_to_chat(122,"Unlimited Shot active. Using custom ammo.")
				equip({ammo=U_Shot_Ammo[player.equipment.range]})
			elseif player.inventory[DefaultAmmo[player.equipment.range]] or player.wardrobe[DefaultAmmo[player.equipment.range]] then
				add_to_chat(122,"Unlimited Shot active but no custom ammo available. Using default ammo.")
				equip({ammo=DefaultAmmo[player.equipment.range]})
			else
				add_to_chat(122,"Unlimited Shot active but unable to find any custom or default ammo.")
			end
		end
	else
		if player.equipment.ammo == U_Shot_Ammo[player.equipment.range] and player.equipment.ammo ~= DefaultAmmo[player.equipment.range] then
			if DefaultAmmo[player.equipment.range] then
				if player.inventory[DefaultAmmo[player.equipment.range]] then
					add_to_chat(122,"Unlimited Shot not active. Using Default Ammo")
					equip({ammo=DefaultAmmo[player.equipment.range]})
				else
					add_to_chat(122,"Default ammo unavailable.  Removing Unlimited Shot ammo.")
					equip({ammo=empty})
				end
			else
				add_to_chat(122,"Unable to determine default ammo for current weapon.  Removing Unlimited Shot ammo.")
				equip({ammo=empty})
			end
		elseif player.equipment.ammo == 'empty' then
			if DefaultAmmo[player.equipment.range] then
				if player.inventory[DefaultAmmo[player.equipment.range]] then
					add_to_chat(122,"Using Default Ammo")
					equip({ammo=DefaultAmmo[player.equipment.range]})
				else
					add_to_chat(122,"Default ammo unavailable.  Leaving empty.")
				end
			else
				add_to_chat(122,"Unable to determine default ammo for current weapon.  Leaving empty.")
			end
		elseif player.inventory[player.equipment.ammo].count < 15 then
			add_to_chat(122,"Ammo '"..player.inventory[player.equipment.ammo].shortname.."' running low ("..player.inventory[player.equipment.ammo].count..")")
		end
	end
end



-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	set_macro_page(1, 12)
end

