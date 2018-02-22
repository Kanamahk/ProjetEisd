local pipe = dark.pipeline()
pipe:basic()
pipe:lexicon("#FirstName", "Lexiques/Lexique_CharactersFirstname.txt")
pipe:lexicon("#SurName", "Lexiques/Lexique_CharactersSurname.txt")
pipe:lexicon("#NickName", "Lexiques/Lexique_Alias.txt")
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
pipe:lexicon("#Organization", lexo)
pipe:lexicon("#Possessif", {"her","his","theirs"})
pipe:lexicon("#Demonstratif", {"her","him","them"})
pipe:lexicon("#Pronoun", {"she","he","they"})
pipe:lexicon("#Individual", {"individual", "person", "one of the", "one"})
pipe:lexicon("#people", {"someone", "anyone"})
pipe:lexicon("#Relation", {"parent", "parents", "father", "mother", "child", "children", "son", "sons", "daughter", "daughters", "brother", "brothers", "sister", "sisters", "cousin", "cousins", "aunt", "aunts", "uncle", "uncles", "wife", "husband"})
pipe:lexicon("#Born", {"birth", "Born", "born", "Birth"})
pipe:lexicon("#Death", {"sentences to death","sentenced to death","sentence to death", "dead","death","Dead","Death","died", "die", "dies"})
pipe:lexicon("#Date", {"date", "time", "age"})
pipe:lexicon("#Place", {"location", "place", "castle", "region", "country", "isle", "island"})
pipe:lexicon("#House", {"house", "House", "Family","family"})
pipe:lexicon("#Appearance", {"looks like","appearance","look"})
pipe:lexicon("#Titles", {"Title", "Titles", "title", "titles"})
pipe:lexicon("#Allegiance", {"allegiance", "Allegiance","allegiances", "Allegiances", "organization","Organization", "organizations","Organizations",})
pipe:lexicon("#Personality", {"personality", "Personality", "psychology"})
pipe:lexicon("#member", {"part of","loyal to", "member of", "members of"})
pipe:lexicon("#Passions", {"passion"})
pipe:lexicon("#QuestionMark", {"Who","who", "What", "what", "Which", "which", "Where", "where", "When", "when", "How", "how", "Why", "why"})
pipe:lexicon("#Aliases", {"called", "known as", "Alias", "NickName", "nicknames", "Nicknames", "nickname", "Nicknamed", "Nicknamed", "named", "Aliases", "aliases", "alias"})
pipe:lexicon("#Singular", {"is", "was", "has"})
pipe:lexicon("#BodPart", {"eye", "eyes", "hair", "face"})
pipe:lexicon("#Color", {"blue","red","brown","white", "black","green", "gold"})
pipe:lexicon("#Hcolor", {"blond","ginger", "redhead","brunette",  })
pipe:lexicon("#Plural", {"are", "were"})
pipe:lexicon("#Past", {"was","were","did", "had","been"})
pipe:lexicon("#Present", {"is", "are", "does", "do"})
pipe:lexicon("#Politeness", {"Do you know","Hello","Hi"})
pipe:lexicon("#Except", {"but", "But"})
pipe:lexicon("#height", {"small", "tall"})
pipe:lexicon("#Some", {"a few", "some", "half"})
pipe:lexicon("#All", {"All", "all", "Everyone", "Every one", "Every single one"  , "everyone", "every one", "every single one" })
pipe:lexicon("#Timestamp", {"current","Current", "former", "Former"})
pipe:lexicon("#IndiceTemp", {"AC", "BC"})
pipe:lexicon("#Det", {"the", "a", "The", "A"})
--Pattern Definitions

pipe:pattern([[
		[#VRB #Past|#Present]
	]])--reconnaissance des Auxiliaires
pipe:pattern([[
		[#Character #Title?? (#FirstName|#NickName) (#Houses|#SurName)?]
	]])--reconnaissance des personnages
pipe:pattern([[
		[#Pers #Character|#Demonstratif|#Possessif|#Pronoun]
	]])--reconnaissance de token qui font reference a des un ou des personnage dont on a eventuellement parlé
 pipe:pattern([[
		[#LoQuestion (Where|where) .* "?"]
	]])--reconnaissance de question concernant un endroit TODO
pipe:pattern([[
		[#Wed (Married|married) to (#Person|#Pers|#Possess)]
	]])--reconnaissance d'une relation marital 
pipe:pattern([[
		[#RelPossess (the #Relation of #Pers|#RelPossess) | (((#Character|#RelPossess) "'" s |#Possessif) #Relation)]
	]])--reconnaissance d'un ou plusieur personnage a partir de leur relation avec un autre
pipe:pattern([[
		[#PosHow How|how #VRB?	]
	]])--reconnaissance de question en How TODO
pipe:pattern([[
		[#Possess 
			(the [#Possessed	
					[#HasPast #Timestamp? 
						(#Titles
						|#House
						|#Allegiance)
					]
					|[#Time (#Born|#Death) #Date|#Place|#House]
					|#Appearance
					|#Aliases
					|[#Physical #Appearance|#BodPart]
					|#Personality
					|#Passion
				] of [#Possessor #Pers|#Possess]) | 
			([#Possessor (#Character|#Possess|#Possessif)] ("'" s)?  [#Possessed	 
					[#Time (#Born|#Death) #Date|#Place|#House]
					|[#HasPast #Timestamp? 
						(#Titles
						|#House
						|#Allegiance)
					]
					|#Aliases
					|#Appearance
					|#Personality
					|#Passion
					
				])
		]
	]])--reconnaissance d'un attribut d'un personnage
pipe:pattern([[
		[#Person ((Who|who) #VRB)? ((the)? #Individual (who is)?)? (#Wed|#RelPossess) #Person? (#VRB)?]
	]])--reconnaissance d'une reference a un personnage
-- pipe:pattern([[
		-- [#Enum 
			-- #Possess (and|","|";"#Enum)?
		-- ]
-- ]])--enumaraiton d'elements TODO
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
	[#WhatQuestion (What|what) ]
]])--reconnaissance d'autre question en What TODO
pipe:pattern([[
	[#PosWhat (What|what) #VRB [#Possess] ]
]])--reconnaissance de question cencernant des attributs de personnages
pipe:pattern([[
	[#ActWho (Who|who) #VRB??
		[#Born #birth (in #Dates)|(at #Places)]
		|[#Dead #death by? #Person]
		|[#Member #member #Organization]
		|[#Also #Alias]
		|[#Reknown #DET #Title]
		|[#Descr 
			[#Eyes #Color (eyes|eyed)]
			|[#Hair #Hcolor|#Color (hair|haired)]
			|[#Height #height]
			]
			
	]
]])--reconnaissance de question generale sur des personnages (Who died by Joffrey?)

return pipe