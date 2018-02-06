--Formalisation de la BD Characters

Characters = { 
	[#]={
		Name = {
			Firstname = {},
			Surname = {},
		},
		Born={
			Date = {},
			Place = {},
			House = {},
		},
		Gender = {},
		Aliases = {},
		Titles = {},
		House = {	
			current = "",
			former = {},
		},
		Family = {
			Parents = {},
			Siblings = {},
		},
		Allegiance = {},
		Culture = {},
		Appearance = {
			description = {}
			Traits = {
				Skin={},
				Eyes={},
				Hair={},
			},
		},
		Personality = {},
		Passions = {},
		Books = {
			POV = {},
			Appearance = {},
			Mentioned = {}
		},
		history = 
		{
			period = {
				1 = {
					name = ,
					action = id,
				},
				2 = {
					name = ,
					action = id,
				},
			}
		},
		Recent Events = {
				1 = {
					book = ,
					action = id,
				},
				2 = {
					book = ,
					action = id,
				},
				3 = {
					book = ,
					action = id,
				},
				4 = {
					book = ,
					action = id,
				},
			},
		},
	},
}