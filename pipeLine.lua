local pipe = dark.pipeline()
pipe:basic()
pipe:lexicon("#FirstName", "Lexiques/Lexique_CharactersFirstname.txt")
pipe:lexicon("#Aliase", "Lexiques/Lexique_Alias.txt")
pipe:lexicon("#Title", "Lexiques/Lexique_Titles.txt")
pipe:lexicon("#Quit", {"quit", "Quit", "QUIT", "good bye", "bye", "see you later"})
-- pipe:model("model/postag-en")
lexh ={}
for line in io.lines("Lexiques/Houses.txt") do
	for sen in line:gmatch("[^,]+") do
		sen = sen:gsub("^%s*", ""):gsub("%s*$", "")
		lexh[#lexh + 1] = sen
		--lexh[#lexh + 1] = sen:lower()
	end
end

--line =line:gsub(", ", ",")
	--for sen in line:gmatch(".-[,]") do
		--sen =sen:gsub(",", "")
		--lexh[#lexh+1] = sen
		--end
--	end
	
pipe:lexicon("#Houses", lexh)
pipe:lexicon("#SurName", "Lexiques/Lexique_CharactersSurname.txt")
lexc ={}
for line in io.lines("Lexiques/Castles.txt") do
	for sen in line:gmatch("[^,]+") do
		lexc[#lexc+1] = sen:gsub("^%s", ""):gsub("%s*$", "")
		end
	end
pipe:lexicon("#Castle", lexc)
	
lexc ={}
for line in io.lines("Lexiques/Cities.txt") do
	for sen in line:gmatch("[^,]+") do
		lexc[#lexc+1] = sen:gsub("^%s", ""):gsub("%s*$", ""):gsub("%p", " %0 ")
		end
	end
pipe:lexicon("#City", lexc)

lexr ={}
for line in io.lines("Lexiques/Regions.txt") do
	for sen in line:gmatch("[^,]+") do
		sen =sen:gsub("^%s", ""):gsub("%s*$", "")
		lexr[#lexr+1] = sen
		lexr[#lexr+1] = sen:lower()
		end
	end
pipe:lexicon("#Region", lexr)

lexi ={}
for line in io.lines("Lexiques/Islands.txt") do
	for sen in line:gmatch("[^,]+") do
		sen =sen:gsub("^%s", ""):gsub("%s*$", "")
		lexi[#lexi+1] = sen
		lexi[#lexi+1] = sen:lower()
		end
	end
pipe:lexicon("#Island", lexi)

lexo ={}
for line in io.lines("Lexiques/Organizations.txt") do
	for sen in line:gmatch("[^;]+") do
		lexo[#lexo+1] = sen:gsub("%p", " %0 "):gsub("^%s", ""):gsub("%s*$", "")
		end
	end
pipe:lexicon("#Allegiances", lexo)
pipe:lexicon("#UselssAdj", {"really", "trully", "greatly"})
pipe:lexicon("#Possessif", {"her","his","theirs"})
pipe:lexicon("#Demonstratif", {"her","him","them"})
pipe:lexicon("#Pronoun", {"she","he","they"})
pipe:lexicon("#Individual", {"individual", "person", "one of the", "one"})
pipe:lexicon("#people", {"someone", "anyone"})
pipe:lexicon("#Relation", {"parent", "parents", "father", "mother", "child", "children", "son", "sons", "daughter", "daughters", "brother", "brothers", "sister", "sisters", "cousin", "cousins", "aunt", "aunts", "uncle", "uncles", "wife", "husband"})
pipe:lexicon("#Born", {"birth", "Born", "born", "Birth"})
pipe:lexicon("#Died", {"sentences to death","sentenced to death","sentence to death", "dead","death","Dead","Death","died", "die", "dies"})
pipe:lexicon("#Date", {"date", "time", "age"})
pipe:lexicon("#Place", {"location", "place", "places", "castle", "region", "country", "isle", "island"})
pipe:lexicon("#House", {"houses", "Houses","house", "House", "Family","family"})
pipe:lexicon("#Race", {"race", "specie", "races", "Race", "Races"})
pipe:lexicon("#Culture", {"culture", "cultures"})
pipe:lexicon("#Gender", {"sex", "gender"})
pipe:lexicon("#Appearance", {"looks like","appearance","look"})
pipe:lexicon("#Titles", {"Title", "Titles", "title", "Titled", "titled", "titles", "entitled"})
pipe:lexicon("#Allegiance", {"allegiance", "Allegiance","allegiances", "Allegiances", "organization","Organization", "organizations","Organizations",})
pipe:lexicon("#Personality", {"personality", "Personality", "psychology"})
pipe:lexicon("#member", {"part of","loyal to", "member of", "members of", "among the", "in the"})
pipe:lexicon("#Passions", {"passion"})
pipe:lexicon("#QuestionMark", {"Who","who", "What", "what", "Which", "which", "Where", "where", "When", "when", "How", "how", "Why", "why"})
pipe:lexicon("#Aliases", {"called", "known as", "Alias", "NickName", "nicknames", "Nicknames", "nickname", "Nicknamed", "Nicknamed", "named", "Aliases", "aliases", "alias"})
pipe:lexicon("#Singular", {"is", "was", "has"})
pipe:lexicon("#Eyes", {"eye", "eyes", "eyed"})
pipe:lexicon("#Hair", {"hair", "haired"})
pipe:lexicon("#Skin", {"skin", "skins", "skined"})
pipe:lexicon("#Color", {"blue","red","brown","white", "black","green", "gold"})
pipe:lexicon("#Colors", {"color", "colored"})
pipe:lexicon("#Hcolor", {"blond","ginger", "redhead","brunette",  })
pipe:lexicon("#Plural", {"are", "were"})
pipe:lexicon("#Past", {"was","were","did", "had","been"})
pipe:lexicon("#Present", {"is", "are", "does", "do", "has", "have"})
pipe:lexicon("#Politeness", {"Do you know","Hello","Hi"})
pipe:lexicon("#Except", {"but", "But"})
pipe:lexicon("#height", {"small", "tall"})
pipe:lexicon("#Some", {"a few", "some", "half"})
pipe:lexicon("#All", {"All", "all", "Everyone", "Every one", "Every single one"  , "everyone", "every one", "every single one" })
pipe:lexicon("#Timestamp", {"current", "Current", "currently", "former", "Former", "formerly", "claim", "Claim", "claimed"})
pipe:lexicon("#IndiceTemp", {"AC", "BC"})
pipe:lexicon("#Genders", {"male", "man", "men", "female", "woman", "women", "girl", "boy"})
pipe:lexicon("#Det", {"the", "a", "The", "A"})
pipe:lexicon("#linkEnum", {",", ";", "and"})
--Pattern Definitions

pipe:pattern([[
		[#VRB #Past|#Present]
	]])--reconnaissance des Auxiliaires
pipe:pattern([[
		[#Character #Title?? (#FirstName|#Aliase) (#Houses|#SurName)?]
	]])--reconnaissance des personnages
pipe:pattern([[
		[#Pers #Character|#Demonstratif|#Possessif|#Pronoun]
	]])--reconnaissance de token qui font reference a des un ou des personnage dont on a eventuellement parlé



pipe:pattern([[
		[#Possess 
			(the [#Possessed	
					[#HasPast #Timestamp? ((#linkEnum|or) #Timestamp)?? 
						(#Titles
						|#House
						|#Allegiance)
					]
					|[#Time (#Born|#Died) (#Date|#Place|#House)]
					|#Gender
					|#Culture
					|#Race
					|#Aliases
					|[#Physical (#Appearance|#Eyes|#Skin|#Hair) #Colors?]
					|#Personality
					|#Passion
				] (#linkEnum [#EnumAt [#Time (#Born|#Died) (#Date|#Place|#House)]
					|[#HasPast #Timestamp? ((#linkEnum|or) #Timestamp)?? 
						(#Titles
						|#House
						|#Allegiance)
					]
					|#Aliases
					|#Gender
					|#Culture
					|#Race
					|[#Physical (#Appearance|#Eyes|#Skin|#Hair) #Colors?]
					|#Personality
					|#Passion])* of [#Possessor #Pers|#RelPossess] [#PossEnum (#linkEnum [#PossInEnum (#Pers|#RelPossess)])]*) | 
			([#Possessor (#Character|#RelPossess|#Possessif)] [#PossEnum (#linkEnum [#PossInEnum (#Character|#RelPossess|#Possessif)])]* ("'" s)?  [#Possessed	 
					[#Time (#Born|#Died) (#Date|#Place|#House)]
					|[#HasPast #Timestamp? ((#linkEnum|or) #Timestamp)?? 
						(#Titles
						|#House
						|#Allegiance)
					]
					|#Aliases
					|#Gender
					|#Culture
					|#Race
					|[#Physical (#Appearance|#Eyes|#Skin|#Hair) #Colors?]
					|#Personality
					|#Passion
					
				] (#linkEnum [#EnumAt [#Time (#Born|#Died) (#Date|#Place|#House)]
					|[#HasPast #Timestamp? ((#linkEnum|or) #Timestamp)?? 
						(#Titles
						|#House
						|#Allegiance)
					]
					|#Aliases
					|#Gender
					|#Culture
					|#Race
					|[#Physical (#Appearance|#Eyes|#Skin|#Hair) #Colors?]
					|#Personality
					|#Passion])*)
		]
	]])--reconnaissance d'un attribut d'un personnage
pipe:pattern([[
		[#RelPossess (the 
			[#EnumRel 
				#Relation (#linkEnum #Relation)*
				] of 
			[#Possessor (#Pers|#RelPossess)][#PossEnum (#linkEnum [#PossInEnum (#Pers|#RelPossess)])]* ) | (
			[#Possessor (#Character|#RelPossess|#Possessif) ][#PossEnum (#linkEnum [#PossInEnum (#Character|#RelPossess|#Possessif)])]*("'" s)? 
				[#EnumRel 
					#Relation (#linkEnum #Relation)*
				])
		]
	]])--reconnaissance d'un ou plusieur personnage a partir de leur relation avec un autre
pipe:pattern([[
		[#Person ((Who|who) #VRB)? ((the)? #Individual (who is)?)? (#Wed|#RelPossess) #Person? (#VRB)?]
	]])--reconnaissance d'une reference a un personnage
pipe:pattern([[
		[#Wed (Married|married) to [#Who (#Person|#Pers|#RelPossess)] ]
	]])--reconnaissance d'une relation marital 
pipe:pattern([[
		[#Dates 
			[#Annee 
				#d
				>(#IndiceTemp)
			] #IndiceTemp
		]
]])--reconnaissances de dates
pipe:pattern([[
    [#Places
            #castle
            | #city
            | #isle
            | #region 
    ]
]])--reconnaissance de lieux

pipe:pattern([[
		[#PosHow How|how #VRB? #Pers 
			[#What (#Alias|#Titles|#Possess)
			]
		]
	]])--reconnaissance de question en How TODO
pipe:pattern([[
	[#WhatPrecPossess (What|what) #VRB?  #Det [#Wanted (#Colors|#Place|#Date)] ((linkEnum|or) [#EnumWat (#Colors|#Place|#Date)] )* of #Possess (#linkEnum #Possess)*]
]])--reconnaissance dee qusetion plus precises en en What TODO
pipe:pattern([[
	[#PosWhat (What|what) #VRB #Possess (#linkEnum #Possess)*]
]])--reconnaissance de question cencernant des attributs de personnages

pipe:pattern([[
	[#ActWho (Who|who) #VRB?? [#Action
		([#Time 
			(#Born|#Died) ((by? #Person)|(in (#Dates|#Houses))|(at #Places))
		]
		|[#HasPast #Timestamp? ((and|","|or) #Timestamp)??
			((#member (#Allegiances|#Houses))
			|(#Titles? #DET? #Title))
		]
		|(#Aliases #Aliase)
		|(#Det? #Genders)
		|[#Descr #UselssAdj*  
			((#Color (#Eyes|#Skin))
			|((#Hcolor|#Color) #Hair?)
			|(#height)
			)])
			
		]
	]
]])--reconnaissance de question generale sur des personnages (Who died by Joffrey?)
 pipe:pattern([[
		[#LoQuestion (Where|where) #VRB #Pers (#linkEnum #Pers)* 
			[#Action 
				#Born
				|#Died
			] (#linkEnum [#EnumAc #Born|#Died])* 
		]
]])--reconnaissance de question concernant un endroit 
pipe:pattern([[
		[#TiQuestion (When|when) #VRB #Pers (#linkEnum #Pers)* 
			[#Action 
				#Born
				|#Died
			] (#linkEnum [#EnumAc #Born|#Died])* 
		]
]])--reconnaissance de question concernant un endroit 
	
return pipe