local pipe = dark.pipeline()
pipe:basic()
pipe:lexicon("#FirstName", "Lexiques/Lexique_CharactersFirstname.txt")
pipe:lexicon("#SurName", "Lexiques/Lexique_CharactersSurname.txt")
pipe:lexicon("#NickName", "Lexiques/Lexique_Alias.txt")
pipe:lexicon("#Title", "Lexiques/Lexique_Titles.txt")
pipe:lexicon("#Quit", {"quit", "Quit", "QUIT", "Aurevoir"})
pipe:model("model/postag-en")
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
	
pipe:lexicon("#House", lexh)
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
pipe:lexicon("#Det", {"the"})
pipe:lexicon("#Relation", {"parent", "parents", "father", "mother", "child", "children", "son", "sons", "daughter", "daughters", "brother", "brothers", "sister", "sisters", "cousin", "cousins", "aunt", "aunts", "uncle", "uncles", "wife", "husband"})
pipe:lexicon("#Born", {"birth", "Born", "born", "Birth", "birth place"})
pipe:lexicon("#QuestionMark", {"Who","who", "What", "Which", "Where", "When", "How", "Why"})
pipe:lexicon("#Aliases", {"called", "known as", "Alias", "NickName", "named", "Aliases", "aliases", "alias"})
pipe:lexicon("#Singular", {"is", "was", "has"})
pipe:lexicon("#Plural", {"are", "were"})
pipe:lexicon("#Past", {"was","were","did"})
pipe:lexicon("#Present", {"is", "are", "does", "do"})
pipe:lexicon("#Titles", {"Title", "Titles", "title", "titles"})
pipe:lexicon("#Appearance", {"looks like","appearance",""})
pipe:lexicon("#Politeness", {"Do you know","Hello","Hi"})
pipe:lexicon("#Except", {"but", "But"})
pipe:lexicon("#Some", {"a few", "some", "half"})
pipe:lexicon("#All", {"All", "all", "Everyone", "Every one", "Every single one"  , "everyone", "every one", "every single one" })
pipe:lexicon("#IndiceTemp", {"AC", "BC"})
--Pattern Definitions

pipe:pattern([[
		[#VRB #Past|#Present]
	]])
pipe:pattern([[
		[#Character #Title?? (#FirstName|#NickName) (#House|#SurName)?]
	]])
pipe:pattern([[
		[#Place (Where|where) #VRB #Possess|#Pers|#Person #POS=VRB]
	]])
 -- pipe:pattern([[
		-- -- [#Subject #POS=VRB #Character #POS=VRB?]
	 -- ]])
pipe:pattern([[
		[#Pers #Character|#Demonstratif|#Possessif|#Pronoun]
	]])
pipe:pattern([[
		[#NQ How|What #VRB #Possess|#w]
	]])
pipe:pattern([[
		[#PQuestion (Who|who) .* "?"]
]])
 pipe:pattern([[
		[#LoQuestion (Where|where) .* "?"]
]])
pipe:pattern([[
		[#Wed (Married|married) to (#Person|#Pers|#Possess)]
	]])
pipe:pattern([[
		[#People (who|Who) #VRB #POS=VRB #w ]
]])
pipe:pattern([[
		[#Enum  (#Person|#Pers|#Alias|#Title) (and|","|";"#Enum)?]
]])
pipe:pattern([[
		[#RelPossess (the #Relation of #Pers|#Possess) | (((#Character|#Possess) "'" s |#Possessif) #Relation)]
]])
pipe:pattern([[
		[#Possess (the #w of #Pers|#Possess) | (((#Character|#Possess) "'" s |#Possessif) #w )]
	]])
pipe:pattern([[
		[#Person ((Who|who) #VRB)? ((the)? #Individual (who is)?)? (#Wed|#RelPossess) #Person? (#VRB)?]
	]])
pipe:pattern([[
		[#Enum 
			#Possess (and|","|";"#Enum)?
		]
]])
pipe:pattern([[
		[#Date 
			[#Annee 
				#d
				>(#IndiceTemp)
			] #IndiceTemp
		]
]])
pipe:pattern([[
    [#Place
            #castle
            | #city
            | #isle
            | #region 
    ]
]])

return pipe