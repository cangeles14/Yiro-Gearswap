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
    indi_timer = ''
    indi_duration = 180
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
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA.Bolster = {body="Bagua Tunic"}
    sets.precast.JA['Life cycle'] = {body="Geomancy Tunic"}

    -- Fast cast sets for spells

    sets.precast.FC = {
		main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}}, -- 5
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}}, -- 3
		head={ name="Merlinic Hood", augments={'"Mag.Atk.Bns."+26','"Fast Cast"+3','INT+8',}}, -- 11
		body={ name="Merlinic Jubbah", augments={'"Fast Cast"+6','MND+9','Mag. Acc.+6',}}, -- 12
		hands="Geo. Mitaines +3",
		legs="Geomancy Pants +2", -- 13
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+8','"Fast Cast"+5','MND+6',}}, -- 10
		neck="Voltsurge Torque", -- 4
		waist="Witful belt", -- 3
		left_ear="Malignance Earring", -- 4
		right_ear="Loquac. Earring", --2
		left_ring="Kishar Ring", --4
		right_ring="Weather. Ring", -- 5
		back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +5','"Fast Cast"+10',}}, -- 10
	}

	-- Total : 80?

    sets.precast.FC.Cure = sets.precast.FC

    sets.precast.FC['Elemental Magic'] = sets.precast.FC

    
    --------------------------------------
	-- Weaponskill sets
	--------------------------------------
	
    -- Default set for any weaponskill that isn't any more specifically defined
	
    sets.precast.WS = {ear2="Moonshade Earring"}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found
	
    sets.precast.WS['Flash Nova'] = {ear2="Moonshade Earring"}

    sets.precast.WS['Starlight'] = {ear2="Moonshade Earring"}

    sets.precast.WS['Moonlight'] = {ear2="Moonshade Earring"}


    --------------------------------------
    -- Midcast sets
    --------------------------------------

    -- Base fast recast for spells
    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.Geomancy = {
		main="Idris",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head="Azimuth Hood +1",
		hands="Geo. Mitaines +3",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Lifestream Cape", augments={'Geomancy Skill +9','Indi. eff. dur. +15',}},
	}
	
    sets.midcast.Geomancy.Indi = {
		main="Idris",
		hands="Geo. Mitaines +3",
		legs={ name="Bagua Pants +1", augments={'Enhances "Mending Halation" effect',}},
		feet="Azimuth Gaiters +1",
		back={ name="Lifestream Cape", augments={'Geomancy Skill +9','Indi. eff. dur. +15',}},
	}
	-- Enhancing Magic
	
	sets.midcast['Enhancing Magic'] = {
		main={ name="Gada", augments={'Enh. Mag. eff. dur. +5','VIT+2','"Mag.Atk.Bns."+7','DMG:+10',}},
		sub="Ammurapi Shield",
		head="Befouled Crown",
		feet="Regal Pumps +1",
		waist="Embla Sash",
		right_ear="Mimir Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
	}
	
	-- Enfeebling Magic ( Accuracy )
	
	sets.midcast['Enfeebling Magic'] = {
		main="Idris", -- 25
		sub="Ammurapi Shield", -- 38
		ammo="Pemphredo Tathlum", -- 8
		head="Jhakri Coronal +2", -- 44
		body="Geomancy Tunic +3", --  50
		hands="Geo. Mitaines +3", -- 48
		legs="Geomancy Pants +2", -- 39
		feet={ name="Bagua Sandals +3", augments={'Enhances "Radial Arcana" effect',}}, -- 36 + (21)
		neck="Erra Pendant", -- 17
		waist="Luminary Sash", -- 10
		left_ear="Malignance Earring", -- 10
		right_ear="Regal Earring", -- 0
		left_ring="Stikini Ring +1", -- 11
		right_ring="Stikini Ring +1", -- 11
		back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +5','"Fast Cast"+10',}}, -- 20
	}
	
	-- Total: 367 ( + 45 Set) (+ 21 Enfeebling) = 433
	sets.midcast.ElementalEnfeeble = sets.midcast['Enfeebling Magic']
	
	sets.midcast['Dark Magic'] = sets.midcast['Enfeebling Magic']
	
	-- Drain / Aspir
	
	sets.midcast.Drain = {
		main="Idris",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +2",
		body="Geomancy Tunic +3",
		hands="Geo. Mitaines +3",
		legs="Geomancy Pants +2",
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+8','"Fast Cast"+5','MND+6',}},
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +5','"Fast Cast"+10',}},
	}
	
	sets.midcast.Aspir = {
		main="Idris",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +2",
		body="Geomancy Tunic +3",
		hands="Geo. Mitaines +3",
		legs="Geomancy Pants +2",
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+8','"Fast Cast"+5','MND+6',}},
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +5','"Fast Cast"+10',}},
	}
	
	-- Stun
	
	sets.midcast.Stun = sets.midcast['Enfeebling Magic']
	
	-- Elemental Magic sets
	
	sets.midcast['Elemental Magic'] = {
		main="Idris",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +2",
		body="Geomancy Tunic +3",
		hands="Geo. Mitaines +3",
		legs="Jhakri Slops +2",
		feet={ name="Bagua Sandals +3", augments={'Enhances "Radial Arcana" effect',}},
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Jhakri Ring",
		right_ring="Stikini Ring +1",
		back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +5','"Fast Cast"+10',}},
	}
	
	-- Cure potency
	
    sets.midcast.Cure = {
		main={ name="Gada", augments={'Enh. Mag. eff. dur. +5','VIT+2','"Mag.Atk.Bns."+7','DMG:+10',}},
		sub="Sors Shield",
		ammo="Staunch Tathlum +1",
		body="Heka's Kalasiris",
		hands={ name="Vanya Cuffs", augments={'MP+50','"Cure" potency +7%','Enmity-6',}},
		legs="Geomancy Pants +2",
		feet="Regal Pumps +1",
		neck="Nodens Gorget",
		waist="Luminary Sash",
		left_ear="Mendi. Earring",
		right_ear="Magnetic Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Solemnity Cape",
	}
    
    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.Protectra = {ring1="Sheltered Ring"}

    sets.midcast.Shellra = {ring1="Sheltered Ring"}

	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {waist="Siegel Sash"})
	

    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    -- Idle Sets

    sets.idle = {
		main="Bolelabunga",
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head="Befouled Crown",
		body="Geomancy Tunic +3",
		hands={ name="Bagua Mitaines +1", augments={'Enhances "Curative Recantation" effect',}},
		legs="Assid. Pants +1",
		feet="Geo. Sandals +2",
		neck="Loricate Torque +1",
		waist="Fucho-no-Obi",
		left_ear="Etiolation Earring",
		right_ear="Genmei Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Nantosuelta's Cape", augments={'Mag. Acc+20 /Mag. Dmg.+20','Pet: "Regen"+10','Damage taken-5%',}},
	}

    sets.idle.PDT = set_combine(sets.idle, {left_ring="Defending Ring",})

    -- Idle Pet Sets
	
    sets.idle.Pet = {
		main="Idris",
		sub="Genmei Shield",
		range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
		head="Azimuth Hood +1",
		body="Geomancy Tunic +3",
		hands="Geo. Mitaines +3",
		legs="Assid. Pants +1",
		feet={ name="Bagua Sandals +3", augments={'Enhances "Radial Arcana" effect',}},
		neck="Loricate Torque +1",
		waist="Isa Belt",
		left_ear="Etiolation Earring",
		right_ear="Genmei Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Nantosuelta's Cape", augments={'Mag. Acc+20 /Mag. Dmg.+20','Pet: "Regen"+10','Damage taken-5%',}},
	}

    sets.idle.PDT.Pet = set_combine(sets.idle.Pet, {left_ring="Defending Ring",})
	
	-- Idle Town
    sets.idle.Town = set_combine(sets.idle, {main="Idris"})

    -- Defense sets

    sets.defense.PDT = set_combine(sets.idle, {left_ring="Defending Ring",})

    sets.defense.MDT = set_combine(sets.idle, {left_ring="Defending Ring",})

    sets.Kiting = set_combine(sets.idle, {left_ring="Defending Ring",})

    sets.latent_refresh = {waist="Fucho-no-obi"}


    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee set
	
    sets.engaged = sets.idle

    --------------------------------------
    -- Custom buff sets
    --------------------------------------

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english:startswith('Indi') then
            if not classes.CustomIdleGroups:contains('Indi') then
                classes.CustomIdleGroups:append('Indi')
            end
            send_command('@timers d "'..indi_timer..'"')
            indi_timer = spell.english
            send_command('@timers c "'..indi_timer..'" '..indi_duration..' down spells/00136.png')
        elseif spell.english == 'Sleep' or spell.english == 'Sleepga' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 60 down spells/00220.png')
        elseif spell.english == 'Sleep II' or spell.english == 'Sleepga II' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 90 down spells/00220.png')
        end
    elseif not player.indi then
        classes.CustomIdleGroups:clear()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if player.indi and not classes.CustomIdleGroups:contains('Indi')then
        classes.CustomIdleGroups:append('Indi')
        handle_equipping_gear(player.status)
    elseif classes.CustomIdleGroups:contains('Indi') and not player.indi then
        classes.CustomIdleGroups:clear()
        handle_equipping_gear(player.status)
    end
end

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

function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Geomancy' then
            if spell.english:startswith('Indi') then
                return 'Indi'
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
    classes.CustomIdleGroups:clear()
    if player.indi then
        classes.CustomIdleGroups:append('Indi')
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
    set_macro_page(1, 13)
end

