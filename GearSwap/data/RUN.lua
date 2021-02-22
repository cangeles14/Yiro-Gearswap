-- NOTE: I do not play run, so this will not be maintained for 'active' use. 
-- It is added to the repository to allow people to have a baseline to build from,
-- and make sure it is up-to-date with the library API.


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

	-- Load and initialize the include file.
	include('Mote-Include.lua')
end


-- Setup vars that are user-independent.
function job_setup()
	send_command('bind f3 gs c cycle OffenseMode')
	send_command('bind f4 gs c cycle IdleMode')
	send_command('bind f5 gs c cycle WeaponskillMode')
	-- Dressup Race and Face change
	send_command('du self race Hume M')
	send_command('du self face 7a')
	--send_command('du self body 12034')
	--send_command('du self head 12014')
	--send_command('du self feet 12094')
	--send_command('du self hands 12054')
	--send_command('du self legs 12074')
end

function user_unload()
    send_command('unbind f3')
    send_command('unbind f4')
    send_command('unbind f5')
	-- Dressup Race and Face clear
	send_command('du clear self')
end



-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('Normal', 'DT', 'DTAcc','Turtle')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.PhysicalDefenseMode:options('PDT')
    state.IdleMode:options('Normal', 'DT')
	select_default_macro_book()
end


function init_gear_sets()

    sets.enmity = {
		ammo="Staunch Tathlum +1",
		head="Halitus Helm", --8
		body="Emet Harness +1", --10
		hands="Kurys Gloves", -- 9
		legs="Eri. Leg Guards +1", -- 11
		feet="Erilaz Greaves +1", -- 6
		neck={ name="Futhark Torque +2", augments={'Path: A',}}, -- 10
		waist="Kasiri Belt", --3
		left_ear="Etiolation Earring", --
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Pernicious Ring", --5
		right_ring="Supershear Ring", --5
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}}, --10
	}
	
	-- Total Enmity: (77), HP: 2620

	--------------------------------------
	-- Precast sets
	--------------------------------------

	-- Precast sets to enhance JAs
    sets.precast.JA['Vallation'] = set_combine(sets.enmity, {body="Runeist's coat +3", legs="Futhark Trousers +3"})
    sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
    sets.precast.JA['Pflug'] = set_combine(sets.enmity, {feet="Runeist's Bottes +3"})
    sets.precast.JA['Battuta'] = set_combine(sets.enmity, {head="Fu. Bandeau +3"})
    sets.precast.JA['Liement'] = set_combine(sets.enmity, {body="Futhark Coat +3"})
    sets.precast.JA['Lunge'] = {} -- magic attack bonus needed
	sets.precast.JA['Swipe'] = sets.precast.JA['Lunge']
    sets.precast.JA['Gambit'] = set_combine(sets.enmity, {hands="Runeist's Mitons +3"})
    sets.precast.JA['Rayke'] = set_combine(sets.enmity, {feet="Futhark Boots +1"})
    sets.precast.JA['Elemental Sforzo'] = set_combine(sets.enmity, {body="Futhark Coat +3"})
    sets.precast.JA['Swordplay'] = set_combine(sets.enmity, {hands="Futhark Mitons +1"})
    sets.precast.JA['Embolden'] = {}
    sets.precast.JA['Vivacious Pulse'] = set_combine(sets.enmity, {head="Erilaz Galea +1", legs="Runeist's Trousers +2"})
    sets.precast.JA['One For All'] = sets.enmity
    sets.precast.JA['Provoke'] = sets.enmity
	sets.precast.JA['Last Resort'] = sets.enmity
	sets.precast.JA['Souleater'] = sets.enmity


	-- Fast cast sets for spells
    sets.precast.FC = {
		ammo="Staunch Tathlum +1",
		head="Rune. Bandeau +2", --12
		body={ name="Taeon Tabard", augments={'"Fast Cast"+4','"Regen" potency+1',}}, --8
		hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}}, --8
		legs="Aya. Cosciales +2",-- 6
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}}, --8
		neck="Voltsurge Torque", --4
		waist="Flume Belt +1",
		left_ear="Etiolation Earring", --1
		right_ear="Loquac. Earring", --2
		left_ring="Weather. Ring", --5
		right_ring="Kishar Ring", -- 4
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Fast Cast"+10','Spell interruption rate down-10%',}}, --10
	}
	--Total Fastcast: 68 HP: 2540
	
	
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash", legs="Futhark Trousers +3"})	--+8 on legs + 8 on belt, 59+16=75
    --sets.precast.FC['Utsusemi: Ichi'] = sets.precast.FC
    --sets.precast.FC['Utsusemi: Ni'] = sets.precast.FC


	-- Weaponskill sets
	
	--Check for buff 574
	
	sets.precast.WS = {
		ammo="Knobkierrie",
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body={ name="Herculean Vest", augments={'Accuracy+16','Weapon skill damage +3%','DEX+15','Attack+11',}},
		hands="Meg. Gloves +2",
		legs={ name="Herculean Trousers", augments={'"Blood Pact" ability delay -2','DEX+15','Weapon skill damage +6%','Accuracy+16 Attack+16','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
		feet={ name="Herculean Boots", augments={'DEX+10','MND+14','Weapon skill damage +8%','Accuracy+12 Attack+12','Mag. Acc.+16 "Mag.Atk.Bns."+16',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Ishvara Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Ilabrat Ring",
		right_ring="Regal Ring",
		back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
	}
	
    sets.precast.WS['Resolution'] = {
		ammo="Knobkierrie",
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body="Ayanmo Corazza +2",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Samnuha Tights", augments={'STR+8','DEX+9','"Dbl.Atk."+3','"Triple Atk."+2',}},
		feet={ name="Herculean Boots", augments={'DEX+10','MND+14','Weapon skill damage +8%','Accuracy+12 Attack+12','Mag. Acc.+16 "Mag.Atk.Bns."+16',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Niqmaddu Ring",
		right_ring="Regal Ring",
		back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
	}
	
    sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS['Resolution'].Normal, {})
    
	
	sets.precast.WS['Dimidiation'] = {
		ammo="Knobkierrie",
		head={ name="Herculean Helm", augments={'Attack+18','Weapon skill damage +3%','DEX+15','Accuracy+14',}},
		body={ name="Herculean Vest", augments={'Accuracy+16','Weapon skill damage +3%','DEX+15','Attack+11',}},
		hands="Meg. Gloves +2",
		legs={ name="Herculean Trousers", augments={'"Blood Pact" ability delay -2','DEX+15','Weapon skill damage +6%','Accuracy+16 Attack+16','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
		feet={ name="Herculean Boots", augments={'DEX+10','MND+14','Weapon skill damage +8%','Accuracy+12 Attack+12','Mag. Acc.+16 "Mag.Atk.Bns."+16',}},
		neck="Fotia Gorget",
		waist="Grunfeld Rope",
		left_ear="Telos Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Ilabrat Ring",
		right_ring="Regal Ring",
		back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
	}
    
	
	sets.precast.WS['Dimidiation'].Acc = set_combine(sets.precast.WS['Dimidiation'].Normal, {})
    
	sets.precast.WS['Requiescat'] = {}
	
    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'].Normal, {})
	
	sets.precast.WS['Savage Blade'] = {}
	

	--------------------------------------
	-- Midcast sets
	--------------------------------------
	
    sets.midcast.FastRecast = {
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}}
	}
	
	sets.midcast['Enhancing Magic'] = {
		head ="Erilaz Galea +1",
		hands="Runeist's Mitons +2",
		legs={ name="Futhark Trousers +3", augments={'Enhances "Inspire" effect',}},
		neck="Melic Torque",
		right_ear="Mimir Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
	}
    
	sets.midcast['Phalanx'] = {
		head="Erilaz Galea +1",
		body={ name="Herculean Vest", augments={'MND+2','Crit.hit rate+3','Phalanx +4','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
		hands={ name="Herculean Gloves", augments={'Weapon skill damage +2%','STR+5','Phalanx +4','Accuracy+20 Attack+20','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
		legs={ name="Futhark Trousers +3", augments={'Enhances "Inspire" effect',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+3 "Mag.Atk.Bns."+3','Pet: Attack+10 Pet: Rng.Atk.+10','Phalanx +2','Accuracy+1 Attack+1',}},
		neck="Melic Torque",
		right_ear="Mimir Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
	}
	
	sets.midcast['Stoneskin'] = set_combine(sets.midcast['Enhancing Magic'], {waist="Siegel Sash"})
    
	sets.midcast['Regen'] = set_combine(sets.midcast['Enhancing Magic'],{head="Rune. Bandeau +3", legs="Futhark Trousers +3"})
	
	sets.midcast['Refresh'] = sets.midcast['Enhancing Magic']
    
	sets.midcast.Cure = {feet="Futhark Boots +3"}
	
	sets.midcast['Jettatura'] = sets.enmity
	
	sets.midcast['Geist Wall'] = sets.enmity
	
	sets.midcast['Flash'] = sets.enmity
	
	sets.midcast['Foil'] = sets.enmity
	
	sets.midcast['Stun'] = sets.enmity

	--------------------------------------
	-- Idle/resting/defense/etc sets
	--------------------------------------

    sets.idle = {
		ammo="Staunch Tathlum +1",
		head="Turms Cap +1",
		body="Runeist's Coat +3",
		hands="Turms Mittens +1",
		legs={ name="Carmine Cuisses +1", augments={'HP+80','STR+12','INT+12',}},
		feet="Turms Leggings +1",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring",
		left_ring="Moonlight Ring",
		right_ring="Defending Ring",
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},
	}
    sets.idle.DT = {
		main={ name="Epeolatry", augments={'Path: A',}}, -- PDT-II 25
		sub="Utu Grip",
		ammo="Staunch Tathlum +1", -- DT 3
		head={ name="Fu. Bandeau +3", augments={'Enhances "Battuta" effect',}}, -- PDT 6
		body="Runeist's Coat +3", --
		hands="Runeist's Mitons +2", -- PDT 2
		legs="Eri. Leg Guards +1", -- PDT 7
		feet="Erilaz Greaves +1", -- PDT 5
		neck={ name="Futhark Torque +2", augments={'Path: A',}}, -- DT 5
		waist="Flume Belt +1", -- -- PDT 4
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring",
		left_ring="Moonlight Ring", -- DT 5
		right_ring="Defending Ring", -- DT 10
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}}, -- PDT 10
	}
			-- PDT : 34 | MDT : 0 | DT : 23 
			-- Total PDT : 57 (50 needed before Epeo PDT-II 25) | MDT : 23 ( 21 needed after shell V)
           
	sets.defense.PDT = sets.idle.DT

	sets.defense.MDT = set_combine(sets.idle.DT,{
		head="Volte Cap",
		hands="Turms Mittens +1",}
	)

	--sets.Kiting = {feet="Skadi's Jambeaux +1"}


	--------------------------------------
	-- Engaged sets
	--------------------------------------

    sets.engaged = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Samnuha Tights", augments={'STR+8','DEX+9','"Dbl.Atk."+3','"Triple Atk."+2',}},
		feet="Meg. Jam. +2",
		neck="Anu Torque",
		waist="Ioskeha Belt +1",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring="Ilabrat Ring",
		back={ name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
	}
	
    sets.engaged.DT = {
		ammo="Staunch Tathlum +1", -- DT 3
		head="Turms Cap +1",
		body={ name="Futhark Coat +3", augments={'Enhances "Elemental Sforzo" effect',}}, -- DT 9
		hands="Turms Mittens +1",
		legs="Eri. Leg Guards +1", -- PDT 7
		feet="Turms Leggings +1",
		neck={ name="Futhark Torque +2", augments={'Path: A',}}, -- DT 5
		waist="Flume Belt +1", -- PDT 4
		left_ear="Tuisto Earring", -- 
		right_ear="Odnowa Earring", -- MDT 1
		left_ring="Moonlight Ring", -- DT 5
		right_ring="Defending Ring", -- DT 10
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}}, -- PDT 10
	} 
		
	-- PDT : 21 | MDT : 1 | DT :  32
	-- Total PDT : 53 (50 needed before Epeo PDT-II 25) | MDT : 33 ( 21 needed after shell V)
	
    sets.engaged.DTAcc = {
		ammo="Staunch Tathlum +1", -- DT 3
		head="Turms Cap +1",
		body={ name="Futhark Coat +3", augments={'Enhances "Elemental Sforzo" effect',}}, -- DT 9
		hands="Turms Mittens +1",
		legs="Meg. Chausses +2", -- PDT 6
		feet="Turms Leggings +1",
		neck={ name="Futhark Torque +2", augments={'Path: A',}}, -- DT 5
		waist="Ioskeha Belt +1",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring", -- MDT 1
		left_ring="Moonlight Ring", -- DT 5
		right_ring="Defending Ring", -- DT 10
		back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}}, -- PDT 10
	}

	-- PDT : 16 | MDT : 1 | DT :  32
	-- Total PDT : 48 (50 needed before Epeo PDT-II 25) | MDT : 33 ( 21 needed after shell V)
end

------------------------------------------------------------------
-- Action events
------------------------------------------------------------------

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.

function job_precast(spell, action, spellMap, eventArgs)
end

function job_midcast(spell, action, spellMap, eventArgs)
end

function job_post_midcast(spell, action, spellMap, eventArgs)
end


function job_aftercast(spell)
end


function job_buff_change(buff, gain)
	if buff:lower()=='terror' or buff:lower()=='petrification' or buff:lower()=='sleep' or buff:lower()=='stun' then
		if gain then
			equip(sets.engaged.DT)
        elseif not gain then 
            handle_equipping_gear(player.status)
		end
	end
	if buff:lower()=='souleater' then
		if gain then
			windower.ffxi.cancel_buff(63)
		end
	end
    if state.Buff[buff] ~= nil then
        state.Buff[buff] = gain
    end
    if buff:lower()=='sleep' then
        if gain and player.hp > 500 and player.status == "Engaged" then -- Equip Frenzy Sallet When You Are Asleep
            equip({head="Frenzy Sallet"})
        elseif not gain then -- Take Sallet off
            handle_equipping_gear(player.status)
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.

function select_default_macro_book()
	set_macro_page(1, 2)
end


function get_rune_obi_element()
    weather_rune = buffactive[elements.rune_of[world.weather_element] or '']
    day_rune = buffactive[elements.rune_of[world.day_element] or '']
    
    local found_rune_element
    
    if weather_rune and day_rune then
        if weather_rune > day_rune then
            found_rune_element = world.weather_element
        else
            found_rune_element = world.day_element
        end
    elseif weather_rune then
        found_rune_element = world.weather_element
    elseif day_rune then
        found_rune_element = world.day_element
    end
    
    return found_rune_element
end

function get_obi(element)
    if element and elements.obi_of[element] then
        return (player.inventory[elements.obi_of[element]] or player.wardrobe[elements.obi_of[element]]) and elements.obi_of[element]
    end
end


------------------------------------------------------------------
-- Timer manipulation
------------------------------------------------------------------

-- Add a new run to the custom timers, and update index values for existing timers.


-- Get the command string to create a custom timer for the provided entry.


-- Get the command string to delete a custom timer for the provided entry.


-- Reset all timers


-- Get a count of the number of runes of a given type


-- Remove the oldest rune(s) from the table, until we're below the max_runes limit.
-- If given a value n, remove n runes from the table.


-- Drop the index of all runes of a given type.
-- If the index drops to 0, it is removed from the table.



------------------------------------------------------------------
-- Reset events
------------------------------------------------------------------

windower.raw_register_event('status change',function(new, old)
end)




