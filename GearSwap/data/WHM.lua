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
    state.Buff['Afflatus Solace'] = buffactive['Afflatus Solace'] or false
    state.Buff['Afflatus Misery'] = buffactive['Afflatus Misery'] or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')

    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    --------------------------------------
    -- Precast Sets
    --------------------------------------

    -- Fastcast
	
    sets.precast.FC = {
		main="Sucellus", -- 5
		ammo="Staunch Tathlum +1",
		head="Nahtirah Hat", -- 10
		body="Inyanga Jubbah +2", -- 14
		hands={ name="Fanatic Gloves", augments={'MP+5','"Fast Cast"+7',}}, -- 7
		legs="Aya. Cosciales +2", -- 6
		feet="Regal Pumps +1", -- 5-7
		neck="Voltsurge Torque", -- 4
		waist="Witful Belt", -- 3
		left_ear="Etiolation Earring", -- 1
		right_ear="Malignance Earring", -- 4
		left_ring="Weather. Ring", -- 5
		right_ring="Kishar Ring", --4
		back={ name="Alaunus's Cape", augments={'"Fast Cast"+10','Spell interruption rate down-10%',}}, -- 10
	}
			-- Total : 78/80
			
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {legs="Doyen Pants",})

    sets.precast.FC['Healing Magic'] = {
		main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}}, -- 7
		sub="Sors Shield", -- 5
		ammo="Staunch Tathlum +1",
		head="Nahtirah Hat", -- 10
		body="Inyanga Jubbah +2", -- 14
		hands={ name="Gende. Gages +1", augments={'Phys. dmg. taken -2%','Song spellcasting time -3%',}}, -- 7
		legs="Aya. Cosciales +2", -- 6
		feet="Regal Pumps +1", -- 5
		neck="Loricate Torque +1",
		waist="Witful Belt", -- 3
		left_ear="Nourish. Earring +1", -- 4
		right_ear="Mendi. Earring", -- 5
		left_ring="Weather. Ring", -- 5
		right_ring="Defending Ring",
		back={ name="Alaunus's Cape", augments={'"Fast Cast"+10','Spell interruption rate down-10%',}}, -- 10
	}
		-- Total : 81
		-- DT: 24 | PDT: 2 | MDT: 8
		
    sets.precast.FC.StatusRemoval = sets.precast.FC['Healing Magic']

    sets.precast.FC.Cure = sets.precast.FC['Healing Magic']
    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.CureSolace = sets.precast.FC.Cure
	
    
    --------------------------------------
    -- Job Ability Sets
    --------------------------------------
	
    sets.precast.JA.Benediction = {body="Piety Briault"}

    -- Waltz Set (chr and vit)
	
    sets.precast.Waltz = {}
    
    
    --------------------------------------
    -- Weaponskill Sets
    --------------------------------------

    gear.default.weaponskill_neck = ""
    gear.default.weaponskill_waist = ""
    sets.precast.WS = {
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Aya. Manopolas +2",
		legs="Aya. Cosciales +2",
		feet="Aya. Gambieras +2",
	}

	--------------------------------------
    -- Midcast Sets
    --------------------------------------
    
    sets.midcast.FastRecast = {}
    
    -- Cure Sets
	
    gear.default.obi_waist = ""
    gear.default.obi_back = ""

    sets.midcast.CureSolace = {
		main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}}, -- 0/2
		sub="Genmei Shield",
		ammo="Pemphredo Tathlum", 
		head={ name="Kaykaus Mitra", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}}, -- 10/0
		body="Ebers Bliaud +1",
		hands="Theophany Mitts +3", -- 0/4
		legs="Ebers Pant. +1",
		feet={ name="Kaykaus Boots", augments={'Mag. Acc.+15','"Cure" potency +5%','"Fast Cast"+3',}}, -- 15/0
		neck={ name="Clr. Torque +1", augments={'Path: A',}}, -- 7
		waist="Luminary Sash",
		left_ear="Nourish. Earring +1", -- 3
		right_ear="Mendi. Earring", -- 5
		left_ring="Weather. Ring",
		right_ring="Defending Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','"Cure" potency +10%','Phys. dmg. taken-10%',}}, -- 10
	}
			-- Total : 50 / 6
    
	sets.midcast.Cure = set_combine(sets.midcast.CureSolace, { body="Theo. Briault +3",})

    sets.midcast.Curaga = set_combine(sets.midcast.CureSolace, { body="Theo. Briault +3",})

    sets.midcast.CureMelee = set_combine(sets.midcast.CureSolace, { body="Theo. Briault +3",})

    sets.midcast.Cursna = {
		main={ name="Gada", augments={'Enh. Mag. eff. dur. +5','VIT+2','"Mag.Atk.Bns."+7','DMG:+10',}},
		head={ name="Kaykaus Mitra", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}},
		body="Ebers Bliaud +1",
		hands={ name="Fanatic Gloves", augments={'MP+5','"Fast Cast"+7',}},
		legs="Theo. Pant. +1",
		feet="Regal Pumps +1",
		neck="Malison Medallion",
		back={ name="Alaunus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','"Cure" potency +10%','Phys. dmg. taken-10%',}},
	}

    sets.midcast.StatusRemoval = {
		head="Ebers Cap +1",
		legs="Ebers Pant. +1",
	}
	
	sets.midcast.Erase = set_combine(sets.midcast.StatusRemoval, { neck={ name="Clr. Torque +1", augments={'Path: A',}},})
	
    sets.midcast['Enhancing Magic'] = {
		main={ name="Gada", augments={'Enh. Mag. eff. dur. +5','VIT+2','"Mag.Atk.Bns."+7','DMG:+10',}},
		sub="Ammurapi Shield",
		head="Befouled Crown",
		hands="Dynasty Mitts",
		legs={ name="Piety Pantaloons", augments={'Enhances "Afflatus Misery" effect',}},
		feet={ name="Kaykaus Boots", augments={'Mag. Acc.+15','"Cure" potency +5%','"Fast Cast"+3',}},
		neck="Melic Torque",
		waist="Embla Sash",
		left_ear="Mimir Earring",
	}

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], { neck="Nodens Gorget", waist="Siegel Sash",})

    sets.midcast.Auspice = sets.midcast['Enhancing Magic']

    sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], {legs={ name="Piety Pantaloons", augments={'Enhances "Afflatus Misery" effect',}},})

    sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'], {main="Bolelabunga",
		head="Inyanga Tiara +2",
		body={ name="Piety Briault", augments={'Enhances "Benediction" effect',}},
		legs="Theo. Pant. +1",})

    sets.midcast.Protectra = sets.midcast['Enhancing Magic']

    sets.midcast.Shellra = sets.midcast['Enhancing Magic']

    sets.midcast['Divine Magic'] = sets.midcast['Enhancing Magic']

    sets.midcast['Dark Magic'] = sets.midcast['Enhancing Magic']
	
    sets.midcast.MndEnfeebles = {main="Lehbrailg +2", sub="Mephitis Grip",
        head="Nahtirah Hat",neck="Weike Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Aquasoul Ring",ring2="Sangoma Ring",
        back="Refraction Cape",waist="Demonry Sash",legs="Bokwus Slops",feet="Piety Duckbills +1"}

    sets.midcast.IntEnfeebles = {main="Lehbrailg +2", sub="Mephitis Grip",
        head="Nahtirah Hat",neck="Weike Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Vanir Cotehardie",hands="Yaoyotl Gloves",ring1="Icesoul Ring",ring2="Sangoma Ring",
        back="Refraction Cape",waist="Demonry Sash",legs="Bokwus Slops",feet="Piety Duckbills +1"}
    
	--------------------------------------
    -- Idle Sets
    --------------------------------------
	
    sets.resting = {}
   
    sets.idle = {
		main="Malignance Pole", -- 20
		sub="Enki Strap",
		ammo="Staunch Tathlum +1", -- 3
		head="Befouled Crown",
		body="Theo. Briault +3",
		hands={ name="Chironic Gloves", augments={'STR+10','Weapon skill damage +3%','"Refresh"+1',}},
		legs="Aya. Cosciales +2", -- 5
		feet={ name="Chironic Slippers", augments={'AGI+10','Crit.hit rate+2','"Refresh"+1',}},
		neck="Loricate Torque +1", -- 6
		waist="Fucho-no-Obi",
		left_ear="Etiolation Earring",
		right_ear="Genmei Earring",
		left_ring="Stikini Ring +1",
		right_ring="Defending Ring", -- 10
		back={ name="Alaunus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','"Cure" potency +10%','Phys. dmg. taken-10%',}},
	}
		-- Total: DT: 44 | PDT: 10 
    sets.idle.PDT = sets.idle

    sets.idle.Town = sets.idle
    
    sets.idle.Weak = sets.idle
    
    -- Defense sets

    sets.defense.PDT = sets.idle

    sets.defense.MDT = sets.idle

    sets.Kiting = {feet="Herald's Gaiters"}

    sets.latent_refresh = {waist="Fucho-no-obi"}

	--------------------------------------
    -- Engaged Sets
    --------------------------------------
 
    sets.engaged = {
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Aya. Manopolas +2",
		legs="Aya. Cosciales +2",
		feet="Aya. Gambieras +2",
	}
    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Divine Caress'] = {}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.english == "Paralyna" and buffactive.Paralyzed then
        -- no gear swaps if we're paralyzed, to avoid blinking while trying to remove it.
        eventArgs.handled = true
    end
    
    if spell.skill == 'Healing Magic' then
        gear.default.obi_back = ""
    else
        gear.default.obi_back = ""
    end
end


function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Apply Divine Caress boosting items as highest priority over other gear, if applicable.
    if spellMap == 'StatusRemoval' and buffactive['Divine Caress'] then
        equip(sets.buff['Divine Caress'])
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

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
        if (default_spell_map == 'Cure' or default_spell_map == 'Curaga') and player.status == 'Engaged' then
            return "CureMelee"
        elseif default_spell_map == 'Cure' and state.Buff['Afflatus Solace'] then
            return "CureSolace"
        elseif spell.skill == "Enfeebling Magic" then
            if spell.type == "WhiteMagic" then
                return "MndEnfeebles"
            else
                return "IntEnfeebles"
            end
        end
    end
end


function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    if cmdParams[1] == 'user' and not areas.Cities:contains(world.area) then
        local needsArts = 
            player.sub_job:lower() == 'sch' and
            not buffactive['Light Arts'] and
            not buffactive['Addendum: White'] and
            not buffactive['Dark Arts'] and
            not buffactive['Addendum: Black']
            
        if not buffactive['Afflatus Solace'] and not buffactive['Afflatus Misery'] then
            if needsArts then
                send_command('@input /ja "Afflatus Solace" <me>;wait 1.2;input /ja "Light Arts" <me>')
            else
                send_command('@input /ja "Afflatus Solace" <me>')
            end
        end
    end
end


-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(6, 7)
end

