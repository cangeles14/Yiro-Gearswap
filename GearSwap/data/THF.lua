-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:

    gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
    
    Treasure hunter modes:
        None - Will never equip TH gear
        Tag - Will equip TH gear sufficient for initial contact with a mob (either melee, ranged hit, or Aeolian Edge AOE)
        SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
        Fulltime - Will keep TH gear equipped fulltime

--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false
    
    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Mod')
    state.HybridMode:options('Normal', 'Evasion', 'PDT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
    state.PhysicalDefenseMode:options('Evasion', 'PDT')


    gear.default.weaponskill_neck = "Fotia Gorget"
    gear.default.weaponskill_waist = "Fotia Belt"
    gear.AugQuiahuiz = {name="Quiahuiz Trousers", augments={'Haste+2','"Snapshot"+2','STR+8'}}

    -- Additional local binds
    send_command('bind ^` input /ja "Flee" <me>')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind !- gs c cycle targetmode')
	-- Dressup Race and Face change
	send_command('du self race mithra')
	send_command('du self face 2a')

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !-')
	-- Dressup Race and Face clear
	send_command('du clear self')
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.TreasureHunter = {hands="Plunderer's Armlets +3", waist="Chaac Belt", feet="Skulk. Poulaines +1",}

    sets.buff['Sneak Attack'] = {}

    sets.buff['Trick Attack'] = {}

    -- Job Abilities for TH
    sets.precast.Step = sets.TreasureHunter
    sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter


    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Job Abilities
	
    sets.precast.JA['Collaborator'] = {head="Raider's Bonnet +2"}
	
    sets.precast.JA['Accomplice'] = {head="Raider's Bonnet +2"}
	
    sets.precast.JA['Flee'] = {feet="Pillager's Poulaines +1"}
	
    sets.precast.JA['Hide'] = {body="Pillager's Vest +1"}
	
    sets.precast.JA['Conspirator'] = {} -- {body="Raider's Vest +2"}
	
    sets.precast.JA['Steal'] = {head="Plunderer's Bonnet",hands="Pillager's Armlets +1",legs="Pillager's Culottes +1",feet="Pillager's Poulaines +1"}
	
    sets.precast.JA['Despoil'] = {legs="Raider's Culottes +2",feet="Raider's Poulaines +2"}
	
    sets.precast.JA['Perfect Dodge'] = {hands="Plunderer's Armlets +1"}
	
    sets.precast.JA['Feint'] = {} -- {legs="Assassin's Culottes +2"}

    sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
	
    sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']


    -- Waltz Set (chr and vit)
	
    sets.precast.Waltz = {
		head={ name="Plun. Bonnet +3", augments={'Enhances "Aura Steal" effect',}},
		body={ name="Plunderer's Vest +3", augments={'Enhances "Ambush" effect',}},
		hands={ name="Plun. Armlets +3", augments={'Enhances "Perfect Dodge" effect',}},
		legs={ name="Plun. Culottes +3", augments={'Enhances "Feint" effect',}},
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
	}

    sets.precast.Waltz['Healing Waltz'] = {}


    -- Fastcast
	
    sets.precast.FC = {
		head={ name="Herculean Helm", augments={'Attack+18','Weapon skill damage +3%','DEX+15','Accuracy+14',}},
		body={ name="Taeon Tabard", augments={'"Fast Cast"+4','"Regen" potency+1',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
		neck="Voltsurge Torque",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Weather. Ring",
	}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})


    -- Ranged (snapshot)
	
    sets.precast.RA = {
		head="Meghanada Visor +2",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','Rng.Acc.+20','Rng.Atk.+20',}},
		feet={ name="Adhe. Gamashes +1", augments={'HP+65','"Store TP"+7','"Snapshot"+10',}},
	}


    --------------------------------------
    -- Weakponskill Sets
    --------------------------------------

    -- Default Weaponskills
	
    sets.precast.WS = {
		ammo="Voluspa Tathlum",
		head={ name="Plun. Bonnet +3", augments={'Enhances "Aura Steal" effect',}},
		body={ name="Plunderer's Vest +3", augments={'Enhances "Ambush" effect',}},
		hands={ name="Plun. Armlets +3", augments={'Enhances "Perfect Dodge" effect',}},
		legs={ name="Plun. Culottes +3", augments={'Enhances "Feint" effect',}},
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Regal Ring",
		right_ring="Ilabrat Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Damage taken-5%',}},
	}
		
    sets.precast.WS.Acc = sets.precast.WS

    -- Specific Weaponskills
	
    sets.precast.WS['Exenterator'] = {
		ammo="Voluspa Tathlum",
		head={ name="Plun. Bonnet +3", augments={'Enhances "Aura Steal" effect',}},
		body={ name="Plunderer's Vest +3", augments={'Enhances "Ambush" effect',}},
		hands="Meg. Gloves +2",
		legs={ name="Plun. Culottes +3", augments={'Enhances "Feint" effect',}},
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Brutal Earring",
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Ilabrat Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Damage taken-5%',}},
	}
    sets.precast.WS['Exenterator'].Acc = sets.precast.WS['Exenterator']
    sets.precast.WS['Exenterator'].Mod = sets.precast.WS['Exenterator']
    sets.precast.WS['Exenterator'].SA = sets.precast.WS['Exenterator']
    sets.precast.WS['Exenterator'].TA = sets.precast.WS['Exenterator']
    sets.precast.WS['Exenterator'].SATA = sets.precast.WS['Exenterator']

    sets.precast.WS["Rudra's Storm"] = {
		ammo="Voluspa Tathlum",
		head={ name="Plun. Bonnet +3", augments={'Enhances "Aura Steal" effect',}},
		body={ name="Plunderer's Vest +3", augments={'Enhances "Ambush" effect',}},
		hands="Meg. Gloves +2",
		legs={ name="Plun. Culottes +3", augments={'Enhances "Feint" effect',}},
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Grunfeld Rope",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Ilabrat Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Damage taken-5%',}},
	}
    sets.precast.WS["Rudra's Storm"].Acc = sets.precast.WS["Rudra's Storm"]
    sets.precast.WS["Rudra's Storm"].Mod = sets.precast.WS["Rudra's Storm"]
    sets.precast.WS["Rudra's Storm"].SA = {
		ammo="Voluspa Tathlum",
		head="Pill. Bonnet +2",
		body={ name="Plunderer's Vest +3", augments={'Enhances "Ambush" effect',}},
		hands="Meg. Gloves +2",
		legs={ name="Plun. Culottes +3", augments={'Enhances "Feint" effect',}},
		feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Grunfeld Rope",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Ilabrat Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Damage taken-5%',}},
	}
    sets.precast.WS["Rudra's Storm"].TA = sets.precast.WS["Rudra's Storm"].SA
    sets.precast.WS["Rudra's Storm"].SATA = sets.precast.WS["Rudra's Storm"].SA

    sets.precast.WS['Aeolian Edge'] = {
		ammo="Pemphredo Tathlum",
		head={ name="Plun. Bonnet +3", augments={'Enhances "Aura Steal" effect',}},
		body={ name="Herculean Vest", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','Weapon skill damage +4%','"Mag.Atk.Bns."+10',}},
		hands={ name="Herculean Gloves", augments={'Mag. Acc.+13 "Mag.Atk.Bns."+13','Weapon skill damage +4%','MND+5','"Mag.Atk.Bns."+15',}},
		legs={ name="Herculean Trousers", augments={'"Blood Pact" ability delay -2','DEX+15','Weapon skill damage +6%','Accuracy+16 Attack+16','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
		feet={ name="Herculean Boots", augments={'DEX+10','MND+14','Weapon skill damage +8%','Accuracy+12 Attack+12','Mag. Acc.+16 "Mag.Atk.Bns."+16',}},
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Regal Ring",
		right_ring="Dingir Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Damage taken-5%',}},
	}

    sets.precast.WS['Aeolian Edge'].TH = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunter)


    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {}

    -- Specific Spells
    sets.midcast.Utsusemi = {}

    -- Ranged gear
    sets.midcast.RA = {
		head="Meghanada Visor +2",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Iskur Gorget",
		waist="Reiki Yotai",
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring="Defending Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Damage taken-5%',}},
	}

    sets.midcast.RA.Acc = sets.midcast.RA


    --------------------------------------
    -- Idle/resting/defense sets
    --------------------------------------

    -- Resting Sets
	
    sets.resting = {}


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {
		ammo="Staunch Tathlum +1",
		head="Meghanada Visor +2",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}},
	}

    sets.idle.Town = {
		ammo="Staunch Tathlum +1",
		head={ name="Plun. Bonnet +3", augments={'Enhances "Aura Steal" effect',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Dedition Earring",
		right_ear="Telos Earring",
		left_ring="Defending Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}},
	}

    sets.idle.Weak = sets.defense.PDT


    -- Defense sets

    sets.defense.PDT = {
		ammo="Staunch Tathlum +1",
		head="Meghanada Visor +2",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Moonlight Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}},
	}

    sets.defense.MDT = sets.defense.PDT
	
	sets.defense.Evasion = sets.defense.PDT


    --------------------------------------
    -- Melee sets
    --------------------------------------

    -- Normal
	
    sets.engaged = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs="Malignance Tights",
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck="Iskur Gorget",
		waist="Reiki Yotai",
		left_ear="Dedition Earring",
		right_ear="Telos Earring",
		left_ring="Gere Ring",
		right_ring="Hetairoi Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}},
	}
		
    sets.engaged.Acc = {
		ammo="Yamarang",
		head={ name="Plun. Bonnet +3", augments={'Enhances "Aura Steal" effect',}},
		body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs="Malignance Tights",
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Gere Ring",
		right_ring="Hetairoi Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}},
	}
        
    -- Mod set for trivial mobs (Skadi+1)
	
    sets.engaged.Mod = sets.engaged

    -- Mod set for trivial mobs (Thaumas)
	
    sets.engaged.Mod2 = sets.engaged

    sets.engaged.Evasion = sets.engaged
		
    sets.engaged.Acc.Evasion = sets.engaged.Acc
	
	-- Hybrid TP Sets
	
	-- Hybrid TP, not full DT
	sets.second = {
		main="Aeneas",
		sub="Tauret",
		ammo="Staunch Tathlum +1",
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body="Malignance Tabard",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs="Malignance Tights",
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Sherida Earring",
		right_ear="Dedition Earring",
		left_ring="Gere Ring",
		right_ring="Moonlight Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}},
	}
	
	-- Full DT Hybrid TP Set
	
	sets.second2 = {
		ammo="Staunch Tathlum +1", -- DT 3
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body="Malignance Tabard", -- DT 9
		hands="Malignance Gloves", -- DT 5
		legs="Malignance Tights", -- DT 7
		feet="Malignance Boots", -- DT 4
		neck={ name="Asn. Gorget +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Defending Ring", -- DT 10
		right_ring="Moonlight Ring", -- DT 5
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}}, -- DT 5
	}
		-- Total: DT 48
		
	-- Change TP set here : second == hybrid and second1 == full DT hybrid
    sets.engaged.PDT = sets.second
		
    sets.engaged.Acc.PDT = sets.engaged.PDT

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
        equip(sets.TreasureHunter)
    elseif spell.english=='Sneak Attack' or spell.english=='Trick Attack' or spell.type == 'WeaponSkill' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
    end
end

-- Run after the general midcast() set is constructed.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
        equip(sets.TreasureHunter)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    local wsmode

    if state.Buff['Sneak Attack'] then
        wsmode = 'SA'
    end
    if state.Buff['Trick Attack'] then
        wsmode = (wsmode or '') .. 'TA'
    end

    return wsmode
end


-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)
    -- Check that ranged slot is locked, if necessary
    check_range_lock()

    -- Check for SATA when equipping gear.  If either is active, equip
    -- that gear specifically, and block equipping default gear.
    check_buff('Sneak Attack', eventArgs)
    check_buff('Trick Attack', eventArgs)
end


function customize_idle_set(idleSet)
    if player.hpp < 80 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end

    return idleSet
end


function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end


-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    th_update(cmdParams, eventArgs)
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
    
    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end
    
    msg = msg .. ', TH: ' .. state.TreasureMode.value

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end


-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end


-- Function to lock the ranged slot if we have a ranged weapon equipped.
function check_range_lock()
    if player.equipment.range ~= 'empty' then
        disable('range', 'ammo')
    else
        enable('range', 'ammo')
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(1, 3)
    elseif player.sub_job == 'WAR' then
        set_macro_page(1, 3)
    elseif player.sub_job == 'NIN' then
        set_macro_page(5, 3)
    else
        set_macro_page(1, 3)
    end
end


