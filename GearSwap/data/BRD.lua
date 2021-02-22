-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:
    
    ExtraSongsMode may take one of three values: None, Dummy, FullLength
    
    You can set these via the standard 'set' and 'cycle' self-commands.  EG:
    gs c cycle ExtraSongsMode
    gs c set ExtraSongsMode Dummy
    
    The Dummy state will equip the bonus song instrument and ensure non-duration gear is equipped.
    The FullLength state will simply equip the bonus song instrument on top of standard gear.
    
    
    Simple macro to cast a dummy Daurdabla song:
    /console gs c set ExtraSongsMode Dummy
    /ma "Shining Fantasia" <me>
    
    To use a Terpander rather than Daurdabla, set the info.ExtraSongInstrument variable to
    'Terpander', and info.ExtraSongs to 1.
--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.ExtraSongsMode = M{['description']='Extra Songs', 'None', 'Dummy', 'FullLength'}

    state.Buff['Pianissimo'] = buffactive['pianissimo'] or false

    -- For tracking current recast timers via the Timers plugin.
    custom_timers = {}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')

    brd_daggers = S{'Izhiikoh', 'Vanir Knife', 'Atoyac', 'Aphotic Kukri', 'Sabebus'}
    pick_tp_weapon()
    
    -- Adjust this if using the Terpander (new +song instrument)
    info.ExtraSongInstrument = 'Daurdabla'
    -- How many extra songs we can keep from Daurdabla/Terpander
    info.ExtraSongs = 2
    
    -- Set this to false if you don't want to use custom timers.
    state.UseCustomTimers = M(true, 'Use Custom Timers')
    
    -- Additional local binds
    send_command('bind ^` gs c cycle ExtraSongsMode')
    send_command('bind !` input /ma "Chocobo Mazurka" <me>')
	
	-- Dressup Race and Face change
	send_command('du self race mithra')
	send_command('du self face 2a')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
	-- Dressup Race and Face clear
	send_command('du clear self')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    
    --------------------------------------
    -- Precast/Fast Cast Sets
    --------------------------------------

    sets.precast.FC = {
		main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}}, -- 7
		head="Nahtirah Hat", -- 10
		body="Inyanga Jubbah +2", -- 14
		hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}}, -- 8
		legs="Aya. Cosciales +2", -- 6
		feet={ name="Kaykaus Boots", augments={'Mag. Acc.+15','"Cure" potency +5%','"Fast Cast"+3',}}, -- 3
		neck="Voltsurge Torque", -- 4
		waist="Witful Belt", -- 3
		left_ear="Etiolation Earring", -- 1
		right_ear="Loquac. Earring", -- 2
		left_ring="Kishar Ring", -- 4
		right_ring="Weather. Ring", -- 5
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10','Damage taken-5%',}}, -- 10
	}
	 -- Total: 77
	 
	sets.precast.FC.BardSong =  {
		main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
		head="Fili Calot +1",
		body="Inyanga Jubbah +2", 
		hands={ name="Gende. Gages +1", augments={'Phys. dmg. taken -2%','Song spellcasting time -3%',}},
		legs="Aya. Cosciales +2",
		feet={ name="Telchine Pigaches", augments={'Song spellcasting time -5%',}},
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Defending Ring",
		right_ring="Weather. Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10','Damage taken-5%',}},
	}

    sets.precast.FC.Daurdabla = set_combine(sets.precast.FC.BardSong, {range=info.ExtraSongInstrument})
	
	sets.precast.FC["Honor March"] = set_combine(sets.precast.FC.BardSong,{range="Marsyas"})
	
    sets.precast.FC.Cure = set_combine(sets.precast.FC, {body="Heka's Kalasiris"})

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC, {legs="Doyen pants"})

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
        
    
    --------------------------------------
    -- Job Ability Preast Sets
    --------------------------------------
    
    sets.precast.JA.Nightingale = {feet="Bihu Slippers +3"}
	
    sets.precast.JA.Troubadour = {body="Bihu Justaucorps +3"}
	
    sets.precast.JA['Soul Voice'] = {legs="Bihu Cannions +3"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
    
       
    --------------------------------------
    -- Weaponskill Sets
    --------------------------------------
	
    -- Default Set
	
    sets.precast.WS = {
		range={ name="Linos", augments={'Accuracy+15','Weapon skill damage +3%','STR+5 CHR+5',}},
		head={ name="Bihu Roundlet +3", augments={'Enhances "Con Anima" effect',}},
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Bihu Cuffs +3", augments={'Enhances "Con Brio" effect',}},
		legs={ name="Bihu Cannions +3", augments={'Enhances "Soul Voice" effect',}},
		feet={ name="Bihu Slippers +3", augments={'Enhances "Nightingale" effect',}},
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Grunfeld Rope",
		left_ear="Regal Earring",
		right_ear="Ishvara Earring",
		left_ring="Ilabrat Ring",
		right_ring="Petrov Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Damage taken-5%',}},
	}
    
	
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS)

    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS)

    sets.precast.WS['Mordant Rime'] = set_combine(sets.precast.WS)
	
	sets.precast.WS["Rudra's Storm"] = {
	    --main="Aeneas",
		--sub="Tauret",
		range={ name="Linos", augments={'Accuracy+15','Weapon skill damage +3%','STR+5 CHR+5',}},
		head={ name="Bihu Roundlet +3", augments={'Enhances "Con Anima" effect',}},
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Bihu Cuffs +3", augments={'Enhances "Con Brio" effect',}},
		legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Grunfeld Rope",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Ilabrat Ring",
		right_ring="Petrov Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Damage taken-5%',}},
	}
    
	sets.precast.WS["Savage Blade"] = {
		--main="Kaja Sword",
		--sub="Tauret",
		range={ name="Linos", augments={'Accuracy+15','Weapon skill damage +3%','STR+5 CHR+5',}},
		head={ name="Bihu Roundlet +3", augments={'Enhances "Con Anima" effect',}},
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Bihu Cuffs +3", augments={'Enhances "Con Brio" effect',}},
		legs={ name="Bihu Cannions +3", augments={'Enhances "Soul Voice" effect',}},
		feet={ name="Bihu Slippers +3", augments={'Enhances "Nightingale" effect',}},
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Grunfeld Rope",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Ilabrat Ring",
		right_ring="Petrov Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Damage taken-5%',}},
	}
    
    --------------------------------------
    -- Midcast Sets
    --------------------------------------

	
    sets.midcast.FastRecast = {}
        
    -- Specific Songs
	
    sets.midcast.Ballad = {legs="Fili Rhingrave +1"}
	
    sets.midcast.Lullaby = {
		hands="Brioso Cuffs +1", 
		main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
		range="Marsyas",}
	
    sets.midcast.Madrigal = {head="Fili Calot +1"}
	
    sets.midcast.March = {hands="Fili Manchettes +1"}
	
    sets.midcast.Minuet = {body="Fili Hongreline +1"}
	
    sets.midcast.Minne = {}
	
    sets.midcast.Paeon = {head="Brioso Roundlet +1"}
	
    sets.midcast.Carol = {}
		
    sets.midcast["Sentinel's Scherzo"] = {feet="Fili Cothurnes +1"}
	
    sets.midcast['Magic Finale'] = {}
	
	sets.midcast["Honor March"] = set_combine(sets.midcast.SongEffect,{range="Marsyas"})

    sets.midcast.Mazurka = {range=info.ExtraSongInstrument}
    

    -- Song Buffs
	
    sets.midcast.SongEffect = {
		main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
		sub="Genmei Shield",
		range="Gjallarhorn",
		head="Fili Calot +1",
		body="Fili Hongreline +1",
		hands="Fili Manchettes +1",
		legs="Aya. Cosciales +2",
		feet="Brioso Slippers +2",
		neck="Mnbw. Whistle +1",
		waist="Flume Belt +1",
		left_ear="Etiolation Earring",
		right_ear="Genmei Earring",
		left_ring="Defending Ring",
		right_ring="Moonlight Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10','Damage taken-5%',}},
	}

    -- Song Debuff
	
    sets.midcast.SongDebuff = {
		main="Tauret",
		sub="Ammurapi Shield",
		range="Gjallarhorn",
		head={ name="Bihu Roundlet +3", augments={'Enhances "Con Anima" effect',}},
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Bihu Cuffs +3", augments={'Enhances "Con Brio" effect',}},
		legs={ name="Bihu Cannions +3", augments={'Enhances "Soul Voice" effect',}},
		feet="Brioso Slippers +2",
		neck="Mnbw. Whistle +1",
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Digni. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10','Damage taken-5%',}},
	}

    -- Daurdabla
	
    sets.midcast.Daurdabla = {range=info.ExtraSongInstrument}

    -- Dummy Song
	
    sets.midcast.DaurdablaDummy = {range=info.ExtraSongInstrument}

    -- General Spells
	
    sets.midcast.Cure = {
		head={ name="Kaykaus Mitra", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}},
		body="Heka's Kalasiris",
		hands={ name="Vanya Cuffs", augments={'MP+50','"Cure" potency +7%','Enmity-6',}},
		legs={ name="Kaykaus Tights", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}},
		feet={ name="Kaykaus Boots", augments={'Mag. Acc.+15','"Cure" potency +5%','"Fast Cast"+3',}},
		neck="Nodens Gorget",
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Mendi. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Solemnity Cape",
	}
        
    sets.midcast.Curaga = sets.midcast.Cure
        
    sets.midcast.Stoneskin = set_combine(sets.midcast.Cure, {waist="Siegel Sash"})
        
    sets.midcast.Cursna = set_combine(sets.midcast.Cure, {neck="Malison Medallion",})
    
	--------------------------------------
    -- Idle Sets
    --------------------------------------
	
    sets.idle = {
		sub="Genmei Shield", -- PDT 10
		head="Inyanga Tiara +2", -- MDT 5
		body="Ayanmo Corazza +2", -- DT 6
		hands="Inyan. Dastanas +2", -- MDT 4
		legs="Aya. Cosciales +2", -- DT 5
		feet="Fili Cothurnes +1",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		-- neck="Loricate Torque +1", -- DT 6
		waist="Flume Belt +1", -- PDT 4
		left_ear="Etiolation Earring", -- MDT 3
		right_ear="Genmei Earring", -- PDT 2
		left_ring="Defending Ring", -- DT 10
		right_ring="Stikini Ring +1",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10','Damage taken-5%',}}, -- DT 5
	}
	-- PDT 16 | MDT 12 | DT 32
	--Total PDT 48 | MDT 44 
	
    sets.idle.PDT = sets.idle

    sets.idle.Town = {
		main="Aeneas",
		sub="Genmei Shield",
		range="Daurdabla",
		head={ name="Bihu Roundlet +3", augments={'Enhances "Con Anima" effect',}},
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Bihu Cuffs +3", augments={'Enhances "Con Brio" effect',}},
		legs={ name="Bihu Cannions +3", augments={'Enhances "Soul Voice" effect',}},
		feet="Fili Cothurnes +1",
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		left_ear="Etiolation Earring",
		right_ear="Genmei Earring",
		left_ring="Defending Ring",
		right_ring="Moonlight Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10','Damage taken-5%',}},
	}

    sets.Kiting = {feet="Fili Cothurnes +1"}

    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- TP Set
	
    sets.engaged = {
		main="Aeneas",
		sub="Tauret",
		range={ name="Linos", augments={'Accuracy+15','"Dbl.Atk."+3','Quadruple Attack +3',}},
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Aya. Manopolas +2",
		legs="Aya. Cosciales +2",
		feet="Aya. Gambieras +2",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Telos Earring",
		right_ear="Eabani Earring",
		left_ring="Hetairoi Ring",
		right_ring="Moonlight Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+5','"Dbl.Atk."+10','Damage taken-5%',}},
	}
	
    -- Dual Wield
	
    sets.engaged.DW = {
		main="Aeneas",
		sub="Tauret",
		range={ name="Linos", augments={'Accuracy+15','"Dbl.Atk."+3','Quadruple Attack +3',}},
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Aya. Manopolas +2",
		legs="Aya. Cosciales +2",
		feet="Aya. Gambieras +2",
		neck={ name="Bard's Charm +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Telos Earring",
		right_ear="Eabani Earring",
		left_ring="Hetairoi Ring",
		right_ring="Moonlight Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+5','"Dbl.Atk."+10','Damage taken-5%',}},
	}
	-- Sword Build
	
		--main="Kaja Sword",
		--sub="Aeneas",
	
	-- Dual Wield Daggers
	
		--main="Aeneas",
		--sub="Tauret",
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        -- Auto-Pianissimo
        if ((spell.target.type == 'PLAYER' and not spell.target.charmed) or (spell.target.type == 'NPC' and spell.target.in_party)) and
            not state.Buff['Pianissimo'] then
            
            local spell_recasts = windower.ffxi.get_spell_recasts()
            if spell_recasts[spell.recast_id] < 2 then
                send_command('@input /ja "Pianissimo" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
                eventArgs.cancel = true
                return
            end
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' then
        if spell.type == 'BardSong' then
            -- layer general gear on first, then let default handler add song-specific gear.
            local generalClass = get_song_class(spell)
            if generalClass and sets.midcast[generalClass] then
                equip(sets.midcast[generalClass])
            end
        end
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        if state.ExtraSongsMode.value == 'FullLength' then
            equip(sets.midcast.Daurdabla)
        end

        state.ExtraSongsMode:reset()
    end
end

-- Set eventArgs.handled to true if we don't want automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' and not spell.interrupted then
        if spell.target and spell.target.type == 'SELF' then
            adjust_timers(spell, spellMap)
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','ammo')
        else
            enable('main','sub','ammo')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    pick_tp_weapon()
end


-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    
    return idleSet
end


-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Determine the custom class to use for the given song.
function get_song_class(spell)
    -- Can't use spell.targets:contains() because this is being pulled from resources
    if set.contains(spell.targets, 'Enemy') then
        if state.CastingMode.value == 'Resistant' then
            return 'ResistantSongDebuff'
        else
            return 'SongDebuff'
        end
    elseif state.ExtraSongsMode.value == 'Dummy' then
        return 'DaurdablaDummy'
    else
        return 'SongEffect'
    end
end


-- Function to create custom buff-remaining timers with the Timers plugin,
-- keeping only the actual valid songs rather than spamming the default
-- buff remaining timers.
function adjust_timers(spell, spellMap)
    if state.UseCustomTimers.value == false then
        return
    end
    
    local current_time = os.time()
    
    -- custom_timers contains a table of song names, with the os time when they
    -- will expire.
    
    -- Eliminate songs that have already expired from our local list.
    local temp_timer_list = {}
    for song_name,expires in pairs(custom_timers) do
        if expires < current_time then
            temp_timer_list[song_name] = true
        end
    end
    for song_name,expires in pairs(temp_timer_list) do
        custom_timers[song_name] = nil
    end
    
    local dur = calculate_duration(spell.name, spellMap)
    if custom_timers[spell.name] then
        -- Songs always overwrite themselves now, unless the new song has
        -- less duration than the old one (ie: old one was NT version, new
        -- one has less duration than what's remaining).
        
        -- If new song will outlast the one in our list, replace it.
        if custom_timers[spell.name] < (current_time + dur) then
            send_command('timers delete "'..spell.name..'"')
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "'..spell.name..'" '..dur..' down')
        end
    else
        -- Figure out how many songs we can maintain.
        local maxsongs = 2
        if player.equipment.range == info.ExtraSongInstrument then
            maxsongs = maxsongs + info.ExtraSongs
        end
        if buffactive['Clarion Call'] then
            maxsongs = maxsongs + 1
        end
        -- If we have more songs active than is currently apparent, we can still overwrite
        -- them while they're active, even if not using appropriate gear bonuses (ie: Daur).
        if maxsongs < table.length(custom_timers) then
            maxsongs = table.length(custom_timers)
        end
        
        -- Create or update new song timers.
        if table.length(custom_timers) < maxsongs then
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "'..spell.name..'" '..dur..' down')
        else
            local rep,repsong
            for song_name,expires in pairs(custom_timers) do
                if current_time + dur > expires then
                    if not rep or rep > expires then
                        rep = expires
                        repsong = song_name
                    end
                end
            end
            if repsong then
                custom_timers[repsong] = nil
                send_command('timers delete "'..repsong..'"')
                custom_timers[spell.name] = current_time + dur
                send_command('timers create "'..spell.name..'" '..dur..' down')
            end
        end
    end
end

-- Function to calculate the duration of a song based on the equipment used to cast it.
-- Called from adjust_timers(), which is only called on aftercast().
function calculate_duration(spellName, spellMap)
    local mult = 1
    if player.equipment.range == 'Daurdabla' then mult = mult + 0.3 end -- change to 0.25 with 90 Daur
    if player.equipment.range == "Gjallarhorn" then mult = mult + 0.4 end -- change to 0.3 with 95 Gjall
    
    if player.equipment.main == "Carnwenhan" then mult = mult + 0.1 end -- 0.1 for 75, 0.4 for 95, 0.5 for 99/119
    if player.equipment.main == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.sub == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.neck == "Aoidos' Matinee" then mult = mult + 0.1 end
    if player.equipment.body == "Aoidos' Hngrln. +2" then mult = mult + 0.1 end
    if player.equipment.legs == "Mdk. Shalwar +1" then mult = mult + 0.1 end
    if player.equipment.feet == "Brioso Slippers" then mult = mult + 0.1 end
    if player.equipment.feet == "Brioso Slippers +1" then mult = mult + 0.11 end
    
    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet" then mult = mult + 0.1 end
    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet +1" then mult = mult + 0.1 end
    if spellMap == 'Madrigal' and player.equipment.head == "Aoidos' Calot +2" then mult = mult + 0.1 end
    if spellMap == 'Minuet' and player.equipment.body == "Aoidos' Hngrln. +2" then mult = mult + 0.1 end
    if spellMap == 'March' and player.equipment.hands == 'Ad. Mnchtte. +2' then mult = mult + 0.1 end
    if spellMap == 'Ballad' and player.equipment.legs == "Aoidos' Rhing. +2" then mult = mult + 0.1 end
    if spellName == "Sentinel's Scherzo" and player.equipment.feet == "Aoidos' Cothrn. +2" then mult = mult + 0.1 end
    
    if buffactive.Troubadour then
        mult = mult*2
    end
    if spellName == "Sentinel's Scherzo" then
        if buffactive['Soul Voice'] then
            mult = mult*2
        elseif buffactive['Marcato'] then
            mult = mult*1.5
        end
    end
    
    local totalDuration = math.floor(mult*120)

    return totalDuration
end


-- Examine equipment to determine what our current TP weapon is.
function pick_tp_weapon()
    if brd_daggers:contains(player.equipment.main) then
        state.CombatWeapon:set('Dagger')
        
        if S{'NIN','DNC'}:contains(player.sub_job) and brd_daggers:contains(player.equipment.sub) then
            state.CombatForm:set('DW')
        else
            state.CombatForm:reset()
        end
    else
        state.CombatWeapon:reset()
        state.CombatForm:reset()
    end
end

-- Function to reset timers.
function reset_timers()
    for i,v in pairs(custom_timers) do
        send_command('timers delete "'..i..'"')
    end
    custom_timers = {}
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 18)
end


windower.raw_register_event('zone change',reset_timers)
windower.raw_register_event('logout',reset_timers)

