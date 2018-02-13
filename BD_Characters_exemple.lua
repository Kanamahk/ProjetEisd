return Characters = { 
	[1]={
		Name = {
			Firstname = {
				[1] = {
					value = {"Barristan"},
					trust = {"S-E"},
				},
			},
			Surname = {
				[1] = {
					value = {"Selmy"},
					trust = {"S-E"},
				},
			},
		},
		Born={
			Date = {
				[1] = {
					value = {"236"},
					Period = {"AC"},
					trust = {"S-E"},
				},
				[2] = {
					value = {"237"},
					Period = {"AC"},
					trust = {"S-E"},
				},
			},
			Place = {
				value = {},
				trust = {},
			},
			House = {
				[1] = {
					value = {"Selmy"},
					trust = {"S-E"},
				},
			},
		},
		Gender = {"male"},
		Aliases = {
			"Barristan the Bold, Arstan Whitebeard", "Ser Grandfather", "Barristan the Old", "Old Ser",
		},
		Titles = {
			current = {"Ser", "Hand of the Queen", "Lord Commander of the Queensguard of Queen Daenerys Targaryen"},
			former = {"Lord Commander of the Kingsguard"},
		},
		House = {	
			current = {"Queensguard"},
			former = {"Selmy", "Kingsguard"},
		},
		Relation = {
			[1] = {
				name = {"Lyonel Selmy"},
				lien = {"father"},
			},
			[]
			-- cette information ne sera pas déduite
			--[2] = {
			--	name = {"Arstan Selmy"},
			--	lien = {"great-nephew"},
			--},
		},
		Allegiance = {
			current = {"Queensguard", "House Selmy", "House Targaryen"},
			former = {"Kingsguard"},
		},
		Culture = {"Marcher"},
		Appearance = {
			description = {"tall", "lined features", "strong", "graceful"}
			Traits = {
				Skin={},
				Eyes={"blue", "sad"},
				Hair={"white"},
			},
		},
		Personality = {},
		Passions = {},
		Books = {
			POV = {"A Dance with Dragons", "The Winds of Winter"},
			Appearance = {"A Game of Thrones", "A Clash of Kings", "A Storm of Swords"},
			Mentioned = {"The World of Ice & Fire", "A Feast for Crows"},
		},
		history = 
		{
			period = {
				1 = {
					name = {"Early life"},
					action = id,
				},
				2 = {
					name = {"In the Kingsguard"},
					action = id,
				},
			}
		},
		Recent Events = {
				1 = {
					book = {"A Game of Thrones"},
					action = id,
				},
				2 = {
					book = {"A Clash of Kings"},
					action = id,
				},
				3 = {
					book = {"A Clash of Kings"},
					action = id,
				},
				4 = {
					book = {"A Dance with Dragons"},
					action = id,
				},
				5 = {
					book = {"The Winds of Winter"},
					action = id,
				},
			},
		},
	},
}