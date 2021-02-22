-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Also, you'll need the Shortcuts addon to handle the auto-targetting of the custom pact commands.

--[[
    Custom commands:
    
    gs c petweather
        Automatically casts the storm appropriate for the current avatar, if possible.
    
    gs c siphon
        Automatically run the process to: dismiss the current avatar; cast appropriate
        weather; summon the appropriate spirit; Elemental Siphon; release the spirit;
        and re-summon the avatar.
        
        Will not cast weather you do not have access to.
        Will not re-summon the avatar if one was not out in the first place.
        Will not release the spirit if it was out before the command was issued.
        
    gs c pact [PactType]
        Attempts to use the indicated pact type for the current avatar.
        PactType can be one of:
            cure
            curaga
            buffOffense
            buffDefense
            buffSpecial
            debuff1
            debuff2
            sleep
            nuke2
            nuke4
            bp70
            bp75 (merits and lvl 75-80 pacts)
            astralflow

--]]


-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff["Avatar's Favor"] = buffactive["Avatar's Favor"] or false
    state.Buff["Astral Conduit"] = buffactive["Astral Conduit"] or false

    spirits = S{"LightSpirit", "DarkSpirit", "FireSpirit", "EarthSpirit", "WaterSpirit", "AirSpirit", "IceSpirit", "ThunderSpirit"}
    avatars = S{"Carbuncle", "Fenrir", "Diabolos", "Ifrit", "Titan", "Leviathan", "Garuda", "Shiva", "Ramuh", "Odin", "Alexander", "Cait Sith"}

    magicalRagePacts = S{
        'Inferno','Earthen Fury','Tidal Wave','Aerial Blast','Diamond Dust','Judgment Bolt','Searing Light','Howling Moon','Ruinous Omen',
        'Fire II','Stone II','Water II','Aero II','Blizzard II','Thunder II',
        'Fire IV','Stone IV','Water IV','Aero IV','Blizzard IV','Thunder IV',
        'Thunderspark','Burning Strike','Meteorite','Nether Blast',
        'Meteor Strike','Heavenly Strike','Wind Blade','Geocrush','Grand Fall','Thunderstorm',
        'Holy Mist','Lunar Bay','Night Terror','Level ? Holy','Conflag Strike'}
	


    pacts = {}
    pacts.cure = {['Carbuncle']='Healing Ruby'}
    pacts.curaga = {['Carbuncle']='Healing Ruby II', ['Garuda']='Whispering Wind', ['Leviathan']='Spring Water'}
    pacts.buffoffense = {['Carbuncle']='Glittering Ruby', ['Ifrit']='Crimson Howl', ['Garuda']='Hastega', ['Ramuh']='Rolling Thunder',
        ['Fenrir']='Ecliptic Growl'}
    pacts.buffdefense = {['Carbuncle']='Shining Ruby', ['Shiva']='Frost Armor', ['Garuda']='Aerial Armor', ['Titan']='Earthen Ward',
        ['Ramuh']='Lightning Armor', ['Fenrir']='Ecliptic Howl', ['Diabolos']='Noctoshield', ['Cait Sith']='Reraise II'}
    pacts.buffspecial = {['Ifrit']='Inferno Howl', ['Garuda']='Fleet Wind', ['Titan']='Earthen Armor', ['Diabolos']='Dream Shroud',
        ['Carbuncle']='Soothing Ruby', ['Fenrir']='Heavenward Howl', ['Cait Sith']='Raise II'}
    pacts.debuff1 = {['Shiva']='Diamond Storm', ['Ramuh']='Shock Squall', ['Leviathan']='Tidal Roar', ['Fenrir']='Lunar Cry',
        ['Diabolos']='Pavor Nocturnus', ['Cait Sith']='Eerie Eye'}
    pacts.debuff2 = {['Shiva']='Sleepga', ['Leviathan']='Slowga', ['Fenrir']='Lunar Roar', ['Diabolos']='Somnolence'}
    pacts.sleep = {['Shiva']='Sleepga', ['Diabolos']='Nightmare', ['Cait Sith']='Mewing Lullaby'}
    pacts.nuke2 = {['Ifrit']='Fire II', ['Shiva']='Blizzard II', ['Garuda']='Aero II', ['Titan']='Stone II',
        ['Ramuh']='Thunder II', ['Leviathan']='Water II'}
    pacts.nuke4 = {['Ifrit']='Fire IV', ['Shiva']='Blizzard IV', ['Garuda']='Aero IV', ['Titan']='Stone IV',
        ['Ramuh']='Thunder IV', ['Leviathan']='Water IV'}
    pacts.bp70 = {['Ifrit']='Flaming Crush', ['Shiva']='Rush', ['Garuda']='Predator Claws', ['Titan']='Mountain Buster',
        ['Ramuh']='Chaotic Strike', ['Leviathan']='Spinning Dive', ['Carbuncle']='Meteorite', ['Fenrir']='Eclipse Bite',
        ['Diabolos']='Nether Blast',['Cait Sith']='Regal Scratch'}
    pacts.bp75 = {['Ifrit']='Meteor Strike', ['Shiva']='Heavenly Strike', ['Garuda']='Wind Blade', ['Titan']='Geocrush',
        ['Ramuh']='Thunderstorm', ['Leviathan']='Grand Fall', ['Carbuncle']='Holy Mist', ['Fenrir']='Lunar Bay',
        ['Diabolos']='Night Terror', ['Cait Sith']='Level ? Holy'}
    pacts.astralflow = {['Ifrit']='Inferno', ['Shiva']='Diamond Dust', ['Garuda']='Aerial Blast', ['Titan']='Earthen Fury',
        ['Ramuh']='Judgment Bolt', ['Leviathan']='Tidal Wave', ['Carbuncle']='Searing Light', ['Fenrir']='Howling Moon',
        ['Diabolos']='Ruinous Omen', ['Cait Sith']="Altana's Favor"}

    -- Wards table for creating custom timers   
    wards = {}
    -- Base duration for ward pacts.
    wards.durations = {
        ['Crimson Howl'] = 60, ['Earthen Armor'] = 60, ['Inferno Howl'] = 60, ['Heavenward Howl'] = 60,
        ['Rolling Thunder'] = 120, ['Fleet Wind'] = 120,
        ['Shining Ruby'] = 180, ['Frost Armor'] = 180, ['Lightning Armor'] = 180, ['Ecliptic Growl'] = 180,
        ['Glittering Ruby'] = 180, ['Hastega'] = 180, ['Noctoshield'] = 180, ['Ecliptic Howl'] = 180,
        ['Dream Shroud'] = 180,
        ['Reraise II'] = 3600
    }
    -- Icons to use when creating the custom timer.
    wards.icons = {
        ['Earthen Armor']   = 'spells/00299.png', -- 00299 for Titan
        ['Shining Ruby']    = 'spells/00043.png', -- 00043 for Protect
        ['Dream Shroud']    = 'spells/00304.png', -- 00304 for Diabolos
        ['Noctoshield']     = 'spells/00106.png', -- 00106 for Phalanx
        ['Inferno Howl']    = 'spells/00298.png', -- 00298 for Ifrit
        ['Hastega']         = 'spells/00358.png', -- 00358 for Hastega
        ['Rolling Thunder'] = 'spells/00104.png', -- 00358 for Enthunder
        ['Frost Armor']     = 'spells/00250.png', -- 00250 for Ice Spikes
        ['Lightning Armor'] = 'spells/00251.png', -- 00251 for Shock Spikes
        ['Reraise II']      = 'spells/00135.png', -- 00135 for Reraise
        ['Fleet Wind']      = 'abilities/00074.png', -- 
    }
    -- Flags for code to get around the issue of slow skill updates.
    wards.flag = false
    wards.spell = ''
    
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')

    gear.perp_staff = {name=""}
    
    select_default_macro_book()
end


-- Define sets and vars used by this job file.
function init_gear_sets()

 -- ===================================================================================================================
    --      Sets
    -- ===================================================================================================================
 
    -- Base Damage Taken Set - Mainly used when IdleMode is "DT"
	
    sets.DT_Base = {
		main="Malignance Pole", -- DT 20
		sub="Elan Strap +1",
		ammo="Staunch Tathlum +1", -- DT 3
		head="Beckoner's Horn +1",
		body={ name="Apo. Dalmatica +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		hands="Asteria Mitts +1",
		legs="Assid. Pants +1",
		feet="Herald's Gaiters",
		neck="Loricate Torque +1", -- DT 6
		waist="Regal Belt", -- DT 3
		left_ear="Etiolation Earring", -- MDT 3
		right_ear="Genmei Earring", -- PDT 2
		left_ring="Stikini Ring +1",
		right_ring="Defending Ring", -- DT 10
		back="Solemnity Cape", -- DT 4
	}
	-- Total: 46 DT | 48 PDT | 49 MDT
	
    sets.precast = {}
 
    -- Fast Cast
    sets.precast.FC = {
		main={ name="Grioavolr", augments={'Blood Pact Dmg.+9','Pet: "Mag.Atk.Bns."+21','DMG:+6',}}, --4
		head={ name="Merlinic Hood", augments={'"Mag.Atk.Bns."+26','"Fast Cast"+3','INT+8',}}, --11
		body="Inyanga Jubbah +2", --13
		hands={ name="Merlinic Dastanas", augments={'"Fast Cast"+7','"Mag.Atk.Bns."+6',}}, --7
		legs={ name="Merlinic Shalwar", augments={'"Mag.Atk.Bns."+25','"Fast Cast"+2','MND+7',}}, -- 2
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+8','"Fast Cast"+5','MND+6',}}, --10
		neck="Voltsurge Torque", --4
		waist="Witful Belt",  -- 2
		left_ear="Loquac. Earring", -- 2
		right_ear="Malignance Earring", -- 4
		left_ring="Kishar Ring", -- 4
		right_ring="Weather. Ring", -- 5
		back={ name="Campestres's Cape", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Pet: Magic Damage+10','"Fast Cast"+10',}}, --10
	}
		-- Total : 78
    sets.midcast = {}
 
    --------------------------------------
	-- BP Timer Gear - 15/15 + Summoning Skill
	--------------------------------------
	
    sets.midcast.BP = {
		ammo="Sancus Sachet +1",
		head="Beckoner's Horn +1",
		body="Con. Doublet +3", -- 15
		hands="Inyan. Dastanas +2",
		legs="Beck. Spats +1",
		feet={ name="Glyph. Pigaches +1", augments={'Inc. Sp. "Blood Pact" magic crit. dmg.',}},
		neck="Melic Torque",
		waist="Lucidity Sash",
		left_ear="Etiolation Earring",
		right_ear="Evans Earring",
		left_ring="Stikini Ring +1",
		right_ring="Evoker's Ring",
		back={ name="Campestres's Cape", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10',}},
	}
	
	--------------------------------------
	-- Job Ability Sets
	--------------------------------------
 
    sets.midcast.Siphon = {
		ammo="Sancus Sachet +1",
		head="Beckoner's Horn +1",
		hands="Inyan. Dastanas +2",
		legs="Beck. Spats +1",
		feet="Beck. Pigaches",
		neck="Melic Torque",
		waist="Lucidity Sash",
		left_ear="Etiolation Earring",
		right_ear="Evans Earring",
		left_ring="Stikini Ring +1",
		right_ring="Evoker's Ring",
		back={ name="Campestres's Cape", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10',}},
	}
	
	 
    sets.midcast["Mana Cede"] = {
		hands="Caller's Bracers +1"
	}
 
    sets.midcast["Astral Flow"] = {
		head="Glyphic Horn +1"
	}
	 
    sets.midcast.Summon = set_combine(sets.DT_Base, {
        body="Baayami Robe +1"
    })
	
	--------------------------------------
	-- Magic sets
	--------------------------------------
 
    sets.midcast.Cure = {
		body="Heka's Kalasiris",
		hands={ name="Vanya Cuffs", augments={'MP+50','"Cure" potency +7%','Enmity-6',}},
		feet="Regal Pumps +1",
		neck="Nodens Gorget",
		waist="Witful Belt",
		left_ear="Etiolation Earring",
		right_ear="Mendi. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Solemnity Cape",
	}
 
    sets.midcast.Cursna = set_combine(sets.precast.FC)
	
    sets.midcast.EnmityRecast = set_combine(sets.precast.FC)
	
    sets.midcast.Enfeeble = {
		head="Inyanga Tiara +2",
		body="Inyanga Jubbah +2",
		hands="Inyan. Dastanas +2",
		legs="Inyanga Shalwar +2",
		feet="Inyan. Crackows +1",
		neck="Erra Pendant",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Malignance Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
	}
	
    sets.midcast.Enhancing = {
		main={ name="Gada", augments={'Enh. Mag. eff. dur. +5','VIT+2','"Mag.Atk.Bns."+7','DMG:+10',}},
		sub="Ammurapi Shield",
		head="Befouled Crown",
		hands="Inyan. Dastanas +2",
		feet="Regal Pumps +1",
		neck="Melic Torque",
		waist="Embla Sash",
		left_ear="Etiolation Earring",
		right_ear="Mimir Earring",
		left_ring="Stikini Ring +1",
		right_ring="Kishar Ring",
	}	
	
    sets.midcast.Stoneskin = set_combine(sets.midcast.Enhancing, {waist="Siegel Sash",})
 
    sets.midcast.Nuke = {}
 
    sets.midcast["Refresh"] = set_combine(sets.midcast.Enhancing, {})
 
    sets.midcast["Aquaveil"] = set_combine(sets.midcast.Enhancing, {})
 
	--------------------------------------
	-- Weaponskill sets
	--------------------------------------
	
	 
    sets.midcast["Garland of Bliss"] = {
		head="Convoker's Horn +2",
		body="Con. Doublet +3",
		hands="Convo. Bracers +2",
		legs="Convo. Spats +2",
		feet="Convo. Pigaches +3",
	}
	
    sets.midcast["Shattersoul"] = sets.midcast["Garland of Bliss"]
 
    sets.midcast["Cataclysm"] = sets.midcast["Garland of Bliss"]
 
    sets.pet_midcast = {}
 
    --------------------------------------
	-- Physical Blood Pact Sets
	--------------------------------------
	
    sets.pet_midcast.Physical_BP = {
		main="Nirvana",
		sub="Elan Strap +1",
		ammo="Sancus Sachet +1",
		head={ name="Apogee Crown +1", augments={'MP+80','Pet: Attack+35','Blood Pact Dmg.+8',}},
		body="Con. Doublet +3",
		hands={ name="Apogee Mitts +1", augments={'MP+80','Pet: Attack+35','Blood Pact Dmg.+8',}},
		legs={ name="Enticer's Pants", augments={'MP+50','Pet: Accuracy+15 Pet: Rng. Acc.+15','Pet: Mag. Acc.+15','Pet: Damage taken -5%',}},
		feet="Convo. Pigaches +3",
		neck={ name="Smn. Collar +1", augments={'Path: A',}},
		waist="Regal Belt",
		left_ear="Lugalbanda Earring",
		right_ear="Gelos Earring",
		left_ring="Varar Ring +1",
		right_ring="Varar Ring +1",
		back={ name="Campestres's Cape", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10',}},
	}
 
    sets.pet_midcast.Physical_BP_AM3 = set_combine(sets.pet_midcast.Physical_BP, {})
 
    -- Physical pacts which benefit more from TP than Pet:DA (like single-hit BP)
	
    sets.pet_midcast.Physical_BP_TP = set_combine(sets.pet_midcast.Physical_BP, {})
 
    -- Used for all physical pacts when AccMode is true
	
    sets.pet_midcast.Physical_BP_Acc = set_combine(sets.pet_midcast.Physical_BP, {})
 
    --------------------------------------
	-- Magical Blood Pact Sets
	--------------------------------------
	
    sets.pet_midcast.Magic_BP_Base = {
		main={ name="Grioavolr", augments={'Blood Pact Dmg.+9','Pet: "Mag.Atk.Bns."+21','DMG:+6',}},
		sub="Elan Strap +1",
		ammo="Sancus Sachet +1",
		head={ name="Apogee Crown +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		body="Con. Doublet +3",
		hands={ name="Merlinic Dastanas", augments={'Pet: Mag. Acc.+24 Pet: "Mag.Atk.Bns."+24','Blood Pact Dmg.+8',}},
		legs={ name="Apogee Slacks +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		feet={ name="Apogee Pumps +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		neck={ name="Smn. Collar +1", augments={'Path: A',}},
		waist="Regal Belt",
		left_ear="Lugalbanda Earring",
		right_ear="Gelos Earring",
		left_ring="Varar Ring +1",
		right_ring="Varar Ring +1",
		back={ name="Campestres's Cape", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Pet: Magic Damage+10','"Fast Cast"+10',}},
	}
   
    -- Some magic pacts benefit more from TP than others.
    -- Note: This set will only be used on merit pacts if < 4 merits. Update merit values at the top
	
    sets.pet_midcast.Magic_BP_TP = set_combine(sets.pet_midcast.Magic_BP_Base, {
        legs="Enticer's Pants"
    })
 
    -- NoTP set used when you don't need Enticer's
	
    sets.pet_midcast.Magic_BP_NoTP = set_combine(sets.pet_midcast.Magic_BP_Base, {
        legs={ name="Apogee Slacks +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}}
    })
 
    sets.pet_midcast.Magic_BP_TP_Acc = set_combine(sets.pet_midcast.Magic_BP_TP, {
		feet="Convo. Pigaches +3",
		neck={ name="Smn. Collar +1", augments={'Path: A',}},
		left_ear="Lugalbanda Earring",
		right_ear="Kyrene's Earring",
	})
 
    sets.pet_midcast.Magic_BP_NoTP_Acc = set_combine(sets.pet_midcast.Magic_BP_NoTP, {
		feet="Convo. Pigaches +3",
		neck={ name="Smn. Collar +1", augments={'Path: A',}},
		left_ear="Lugalbanda Earring",
		right_ear="Kyrene's Earring",
	})
	
	-------------------------------------------
	-- Hybrid Blood Pact Sets - Flaming Crush
	-------------------------------------------
 
    sets.pet_midcast.FlamingCrush = {
		main="Nirvana",
		sub="Elan Strap +1",
		ammo="Sancus Sachet +1",
		head={ name="Apogee Crown +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		body="Con. Doublet +3",
		hands={ name="Merlinic Dastanas", augments={'Pet: Mag. Acc.+24 Pet: "Mag.Atk.Bns."+24','Blood Pact Dmg.+8',}},
		legs={ name="Apogee Slacks +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		feet={ name="Apogee Pumps +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		neck={ name="Smn. Collar +1", augments={'Path: A',}},
		waist="Regal Belt",
		left_ear="Lugalbanda Earring",
		right_ear="Gelos Earring",
		left_ring="Varar Ring +1",
		right_ring="Varar Ring +1",
		back={ name="Campestres's Cape", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10',}},
	}
 
    sets.pet_midcast.FlamingCrush_Acc = set_combine(sets.pet_midcast.FlamingCrush, {
        left_ear="Lugalbanda Earring",
		right_ear="Kyrene's Earring",
        feet="Convo. Pigaches +3"
    })
	
	-------------------------------------------
	-- Debuff Pact Sets - Pet Magic Acc
	-------------------------------------------
	
    sets.pet_midcast.MagicAcc_BP = {
		main={ name="Espiritus", augments={'Summoning magic skill +15','Pet: Mag. Acc.+30','Pet: Damage taken -4%',}},
		sub="Elan Strap +1",
		ammo="Sancus Sachet +1",
		head="Convoker's Horn +2",
		body="Con. Doublet +3",
		hands="Convo. Bracers +2",
		legs="Convo. Spats +2",
		feet="Convo. Pigaches +3",
		neck={ name="Smn. Collar +1", augments={'Path: A',}},
		waist="Incarnation Sash",
		left_ear="Lugalbanda Earring",
		right_ear="Enmerkar Earring",
		left_ring="Stikini Ring +1",
		right_ring="Evoker's Ring",
		back={ name="Campestres's Cape", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Pet: Magic Damage+10','"Fast Cast"+10',}},
	}
 
    sets.pet_midcast.Debuff_Rage = sets.pet_midcast.MagicAcc_BP
 
    -- Pure summoning magic set
	
    sets.pet_midcast.SummoningMagic = sets.pet_midcast.MagicAcc_BP
 
    sets.pet_midcast.Buff = sets.pet_midcast.MagicAcc_BP
 
    -- I use Apogee gear for healing BPs because the amount healed is affected by avatar max HP.
    -- I'm probably stupid. It puts you in yellow HP after using a healing move.
	
    sets.pet_midcast.Buff_Healing = sets.pet_midcast.MagicAcc_BP
 
    -- This set is used for certain blood pacts when ImpactDebuff mode is ON. (/console gs c ImpactDebuff)
    -- These pacts are normally used as nukes, but they're also strong debuffs which are enhanced by smn skill.
	
    sets.pet_midcast.Impact = sets.pet_midcast.MagicAcc_BP
 
    sets.aftercast = {}
 
    -------------------------------------------
	-- Idle Set
	-------------------------------------------
    sets.aftercast.Idle = {
		main="Nirvana",
		sub="Elan Strap +1",
		ammo="Staunch Tathlum +1",
		head="Beckoner's Horn +1",
		body={ name="Apo. Dalmatica +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		hands="Asteria Mitts +1",
		legs="Assid. Pants +1",
		feet="Herald's Gaiters",
		neck="Caller's Pendant",
		waist="Incarnation Sash",
		left_ear="Etiolation Earring",
		right_ear="Evans Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Campestres's Cape", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10',}},
	}
   
    -- Idle set used when ForceIlvl is ON. Use this mode to avoid Gaiters dropping ilvl.
	
    sets.aftercast.Idle_Ilvl = set_combine(sets.aftercast.Idle, {})
   
    sets.aftercast.DT = sets.DT_Base
 
    -- Many idle sets inherit from this set.
    -- Put common items here so you don't have to repeat them over and over.
	
    sets.aftercast.Perp_Base = {
		main="Nirvana",
		sub="Elan Strap +1",
		ammo="Sancus Sachet +1",
		head="Beckoner's Horn +1",
		body={ name="Apo. Dalmatica +1", augments={'MP+80','Pet: "Mag.Atk.Bns."+35','Blood Pact Dmg.+8',}},
		hands="Asteria Mitts +1",
		legs="Assid. Pants +1",
		feet="Convo. Pigaches +3",
		neck="Caller's Pendant",
		waist="Fucho-no-Obi",
		left_ear="Etiolation Earring",
		right_ear="Evans Earring",
		left_ring="Stikini Ring +1",
		right_ring="Evoker's Ring",
		back={ name="Campestres's Cape", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10',}},
	}
 
    -- Avatar Melee set. Equipped when IdleMode is "DD" and MeleeMode is OFF.
	
    sets.aftercast.Perp_DD = set_combine(sets.aftercast.Perp_Base, {})
 
    -- Refresh set with avatar out. Equipped when IdleMode is "Refresh".
	
    sets.aftercast.Perp_Refresh = set_combine(sets.aftercast.Perp_Base, {})
 
    sets.aftercast.Perp_RefreshSub50 = set_combine(sets.aftercast.Perp_Refresh, {})
   
    sets.aftercast.Perp_Favor = set_combine(sets.aftercast.Perp_Refresh, {})
 
    sets.aftercast.Perp_Zendik = set_combine(sets.aftercast.Perp_Favor, {})
 
    -- TP set. Equipped when IdleMode is "DD" and MeleeMode is ON.
	
    sets.aftercast.Perp_Melee = set_combine(sets.aftercast.Perp_Refresh, {})
 
    -- Pet:DT build. Equipped when IdleMode is "PetDT".
	
    sets.aftercast.Avatar_DT = {}
 
    -- Perp down set used when ForceIlvl is ON. Use this mode to avoid Selenian Cap dropping ilvl.
	
    sets.aftercast.Avatar_DT_Ilvl = set_combine(sets.aftercast.Avatar_DT, {})
 
    -- DT build with avatar out. Equipped when IdleMode is "DT".
	
    sets.aftercast.Perp_DT = set_combine(sets.DT_Base, {})
 
    sets.aftercast.Spirit = sets.aftercast.Perp_Base
 
    -- ===================================================================================================================
    --      End of Sets
    -- ===================================================================================================================
	
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if state.Buff['Astral Conduit'] and pet_midaction() then
        eventArgs.handled = true
    end
end

function job_midcast(spell, action, spellMap, eventArgs)
    if state.Buff['Astral Conduit'] and pet_midaction() then
        eventArgs.handled = true
    end
end

-- Runs when pet completes an action.
function job_pet_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted and spell.type == 'BloodPactWard' and spellMap ~= 'DebuffBloodPactWard' then
        wards.flag = true
        wards.spell = spell.english
        send_command('wait 4; gs c reset_ward_flag')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    elseif storms:contains(buff) then
        handle_equipping_gear(player.status)
    end
end


-- Called when the player's pet's status changes.
-- This is also called after pet_change after a pet is released.  Check for pet validity.
function job_pet_status_change(newStatus, oldStatus, eventArgs)
    if pet.isvalid and not midaction() and not pet_midaction() and (newStatus == 'Engaged' or oldStatus == 'Engaged') then
        handle_equipping_gear(player.status, newStatus)
    end
end


-- Called when a player gains or loses a pet.
-- pet == pet structure
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(petparam, gain)
    classes.CustomIdleGroups:clear()
    if gain then
        if avatars:contains(pet.name) then
            classes.CustomIdleGroups:append('Avatar')
        elseif spirits:contains(pet.name) then
            classes.CustomIdleGroups:append('Spirit')
        end
    else
        select_default_macro_book('reset')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell)
	
    if spell.type == 'BloodPactRage' then
        if magicalRagePacts:contains(spell.english) then
            return 'MagicalBloodPactRage'
		elseif spell.name=="Flaming Crush" then
			return 'HybridBloodPactRage'
        else
            return 'PhysicalBloodPactRage'
        end
    elseif spell.type == 'BloodPactWard' and spell.target.type == 'MONSTER' then
        return 'DebuffBloodPactWard'
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if pet.isvalid then
        if pet.element == world.day_element then
            idleSet = set_combine(idleSet, sets.perp.Day)
        end
        if pet.element == world.weather_element then
            idleSet = set_combine(idleSet, sets.perp.Weather)
        end
        if sets.perp[pet.name] then
            idleSet = set_combine(idleSet, sets.perp[pet.name])
        end
        gear.perp_staff.name = elements.perpetuance_staff_of[pet.element]
        if gear.perp_staff.name and (player.inventory[gear.perp_staff.name] or player.wardrobe[gear.perp_staff.name]) then
            idleSet = set_combine(idleSet, sets.perp.staff_and_grip)
        end
        if state.Buff["Avatar's Favor"] and avatars:contains(pet.name) then
            idleSet = set_combine(idleSet, sets.idle.Avatar.Favor)
        end
        if pet.status == 'Engaged' then
            idleSet = set_combine(idleSet, sets.idle.Avatar.Melee)
        end
    end
    
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    
    return idleSet
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    classes.CustomIdleGroups:clear()
    if pet.isvalid then
        if avatars:contains(pet.name) then
            classes.CustomIdleGroups:append('Avatar')
        elseif spirits:contains(pet.name) then
            classes.CustomIdleGroups:append('Spirit')
        end
    end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'petweather' then
        handle_petweather()
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'siphon' then
        handle_siphoning()
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'pact' then
        handle_pacts(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1] == 'reset_ward_flag' then
        wards.flag = false
        wards.spell = ''
        eventArgs.handled = true
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Cast the appopriate storm for the currently summoned avatar, if possible.
function handle_petweather()
    if player.sub_job ~= 'SCH' then
        add_to_chat(122, "You can not cast storm spells")
        return
    end
        
    if not pet.isvalid then
        add_to_chat(122, "You do not have an active avatar.")
        return
    end
    
    local element = pet.element
    if element == 'Thunder' then
        element = 'Lightning'
    end
    
    if S{'Light','Dark','Lightning'}:contains(element) then
        add_to_chat(122, 'You do not have access to '..elements.storm_of[element]..'.')
        return
    end 
    
    local storm = elements.storm_of[element]
    
    if storm then
        send_command('@input /ma "'..elements.storm_of[element]..'" <me>')
    else
        add_to_chat(123, 'Error: Unknown element ('..tostring(element)..')')
    end
end


-- Custom uber-handling of Elemental Siphon
function handle_siphoning()
    if areas.Cities:contains(world.area) then
        add_to_chat(122, 'Cannot use Elemental Siphon in a city area.')
        return
    end

    local siphonElement
    local stormElementToUse
    local releasedAvatar
    local dontRelease
    
    -- If we already have a spirit out, just use that.
    if pet.isvalid and spirits:contains(pet.name) then
        siphonElement = pet.element
        dontRelease = true
        -- If current weather doesn't match the spirit, but the spirit matches the day, try to cast the storm.
        if player.sub_job == 'SCH' and pet.element == world.day_element and pet.element ~= world.weather_element then
            if not S{'Light','Dark','Lightning'}:contains(pet.element) then
                stormElementToUse = pet.element
            end
        end
    -- If we're subbing /sch, there are some conditions where we want to make sure specific weather is up.
    -- If current (single) weather is opposed by the current day, we want to change the weather to match
    -- the current day, if possible.
    elseif player.sub_job == 'SCH' and world.weather_element ~= 'None' then
        -- We can override single-intensity weather; leave double weather alone, since even if
        -- it's partially countered by the day, it's not worth changing.
        if get_weather_intensity() == 1 then
            -- If current weather is weak to the current day, it cancels the benefits for
            -- siphon.  Change it to the day's weather if possible (+0 to +20%), or any non-weak
            -- weather if not.
            -- If the current weather matches the current avatar's element (being used to reduce
            -- perpetuation), don't change it; just accept the penalty on Siphon.
            if world.weather_element == elements.weak_to[world.day_element] and
                (not pet.isvalid or world.weather_element ~= pet.element) then
                -- We can't cast lightning/dark/light weather, so use a neutral element
                if S{'Light','Dark','Lightning'}:contains(world.day_element) then
                    stormElementToUse = 'Wind'
                else
                    stormElementToUse = world.day_element
                end
            end
        end
    end
    
    -- If we decided to use a storm, set that as the spirit element to cast.
    if stormElementToUse then
        siphonElement = stormElementToUse
    elseif world.weather_element ~= 'None' and (get_weather_intensity() == 2 or world.weather_element ~= elements.weak_to[world.day_element]) then
        siphonElement = world.weather_element
    else
        siphonElement = world.day_element
    end
    
    local command = ''
    local releaseWait = 0
    
    if pet.isvalid and avatars:contains(pet.name) then
        command = command..'input /pet "Release" <me>;wait 1.1;'
        releasedAvatar = pet.name
        releaseWait = 10
    end
    
    if stormElementToUse then
        command = command..'input /ma "'..elements.storm_of[stormElementToUse]..'" <me>;wait 4;'
        releaseWait = releaseWait - 4
    end
    
    if not (pet.isvalid and spirits:contains(pet.name)) then
        command = command..'input /ma "'..elements.spirit_of[siphonElement]..'" <me>;wait 4;'
        releaseWait = releaseWait - 4
    end
    
    command = command..'input /ja "Elemental Siphon" <me>;'
    releaseWait = releaseWait - 1
    releaseWait = releaseWait + 0.1
    
    if not dontRelease then
        if releaseWait > 0 then
            command = command..'wait '..tostring(releaseWait)..';'
        else
            command = command..'wait 1.1;'
        end
        
        command = command..'input /pet "Release" <me>;'
    end
    
    if releasedAvatar then
        command = command..'wait 1.1;input /ma "'..releasedAvatar..'" <me>'
    end
    
    send_command(command)
end


-- Handles executing blood pacts in a generic, avatar-agnostic way.
-- cmdParams is the split of the self-command.
-- gs c [pact] [pacttype]
function handle_pacts(cmdParams)
    if areas.Cities:contains(world.area) then
        add_to_chat(122, 'You cannot use pacts in town.')
        return
    end

    if not pet.isvalid then
        add_to_chat(122,'No avatar currently available. Returning to default macro set.')
        select_default_macro_book('reset')
        return
    end

    if spirits:contains(pet.name) then
        add_to_chat(122,'Cannot use pacts with spirits.')
        return
    end

    if not cmdParams[2] then
        add_to_chat(123,'No pact type given.')
        return
    end
    
    local pact = cmdParams[2]:lower()
    
    if not pacts[pact] then
        add_to_chat(123,'Unknown pact type: '..tostring(pact))
        return
    end
    
    if pacts[pact][pet.name] then
        if pact == 'astralflow' and not buffactive['astral flow'] then
            add_to_chat(122,'Cannot use Astral Flow pacts at this time.')
            return
        end
        
        -- Leave out target; let Shortcuts auto-determine it.
        send_command('@input /pet "'..pacts[pact][pet.name]..'"')
    else
        add_to_chat(122,pet.name..' does not have a pact of type ['..pact..'].')
    end
end


-- Event handler for updates to player skill, since we can't rely on skill being
-- correct at pet_aftercast for the creation of custom timers.
windower.raw_register_event('incoming chunk',
    function (id)
        if id == 0x62 then
            if wards.flag then
                create_pact_timer(wards.spell)
                wards.flag = false
                wards.spell = ''
            end
        end
    end)

-- Function to create custom timers using the Timers addon.  Calculates ward duration
-- based on player skill and base pact duration (defined in job_setup).
function create_pact_timer(spell_name)
    -- Create custom timers for ward pacts.
    if wards.durations[spell_name] then
        local ward_duration = wards.durations[spell_name]
        if ward_duration < 181 then
            local skill = player.skills.summoning_magic
            if skill > 300 then
                skill = skill - 300
                if skill > 200 then skill = 200 end
                ward_duration = ward_duration + skill
            end
        end
        
        local timer_cmd = 'timers c "'..spell_name..'" '..tostring(ward_duration)..' down'
        
        if wards.icons[spell_name] then
            timer_cmd = timer_cmd..' '..wards.icons[spell_name]
        end

        send_command(timer_cmd)
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book(reset)
    if reset == 'reset' then
        -- lost pet, or tried to use pact when pet is gone
    end
    
    -- Default macro set/book
    set_macro_page(4, 13)
end