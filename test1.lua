pipe = dark.pipeline()
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
pipe:lexicon("#All", {"All", "all", "Everyone", "Every one", "Every single one"  , "evenryone", "every one", "every single one" })
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
		[#Enum #Possess (and|","|";"#Enum)?]
]])

Link = dofile("exempleIndexBD.lua")
Bd = dofile("exempleCharacterBD.lua")
quitting = false

function LocFetch(locations)
	local ret = {}
	local locapipe = pipe(locations)
	
end

function PossRetrieval(possess)
	local ret = {}
	local whowat = PossWhoWat(possess)
	
end

require "math"

function LevenshteinDistance(chain, otherchain)
	local d = {}
	local i = 0
	local j = 0
	local subCost = 0
    
	for i=1,chain:len() do
        d[i] = {}
		d[i][1] = i
	end
	for j=1,otherchain:len() do 
		d[1][j] = j
	end
	for i=2,chain:len() do
		for j=2,otherchain:len() do
			if chain[i] == otherchain[j] then
				subCost = 0
			else
				subCost = 1
			end
			d[i][j] = math.min(d[i - 1][j] + 1, 
								d[i][j - 1] + 1,
								d[i - 1][j - 1] + subCost)
		end
	end
	return d[#chain][#otherchain]
end

function PossWhoWat(pos)
	local ret = {}
	ret["who"] = ""
	ret["wat"] = ""
	if pos:find(" of ") then
		ret["who"] = pos:sub(pos:find(" of ")+string.len(" of "))
		ret["wat"] = pos:sub(pos:find("the ")+ string.len("the "), pos:find(" of ")-1)
	else
		if pos:find(" ' s ") then
			ret["who"] = pos:sub(1, pos:find(" ' s ")-1)
			ret["wat"] = pos:sub(pos:find(" ' s ")+string.len(" ' s "))
		else
			ret["who"] = contextp
			local sif = pipe(pos):tag2str("#Possessif")[1]
			ret["wat"] = pos:sub(pos:find(sif)+sif:len()+1)
		end
	end
	return ret
end

function Whois(persons)
	local ret ={}
	local whos = {}
	ret["list"] = {}
	ret["inpersons"] = 0
	local prec = ""
	local piperson = pipe(persons)
	local dex = #piperson["#Person"]
	local length = 1
	local parc = 1
	while piperson[1][parc]["name"] ~="#Person" do parc = parc +1 end
	length = piperson[1][parc]["length"]
	while dex > 0 do 
	print("LAPATA")
		local lys = piperson:tag2str("#Person")[dex]
		if #piperson["#Wed"]>0 then
			local wedin = 1
			parc = 1
			local w = length
			while piperson["#Wed"][parc] do
				if w > piperson["#Wed"][parc][1] then 
					w = piperson
					wedin = parc
				end
				parc = parc + 1
			end
			local wed = piperson:tag2str("#Wed")[wedin]
			prec = persons:sub(persons:find(wed) + wed:len())
			whos = WeddingRetrieval(wed)
			ret["inpersons"] = ret["inpersons"] + whos["inwedding"]
			dex = dex - whos["inwedding"]
		end
		if #piperson["#Possess"] >0 then
			local posin = 1
			parc = 1
			local p = length
			while piperson["#Posess"][parc] do 
				if p > piperson["#Possess"][parc][1] then 
					p = piperson["#Posess"][parc][1]
					posin = parc
				end
				parc = parc +1
			end
			local poss = piperson:tag2str("#Possess")[1]
			prec = persons:sub(persons:find(poss) + poss:len())
			whos = PossesWhoRetrieval(poss)
			print(table.concat(whos["list"], ""))
		end
		if #whos["list"] == 1 then
			ret["list"][#ret["list"]+1] = whos["list"][1]
		else
			if #whos["list"] > 1 then
				if pipe(prec)["#Person"]>0 then
					percs = Whois(pipe(prec)["#Person"][#pipe(prec)["#Person"]])
					ret["inpersons"] = ret[i"npersons"] + 1 + percs["inpersons"]
					dex = dex - percs["inpersons"]
					local i = 1
					while percs["list"][i] do
						local j =1
						while whos["list"][j] do
							if percs["list"][i] == whos["list"][j] then
								j = j+1
								if table.concat(ret, " "):find(whos["list"][j]) == nil then
									ret["list"][#ret["list"]+1] = whos["list"][j]
								end
							else
								table.remove(whos["list"], j)
							end
						end
						i = i+1
					end
				else
				
				end
			end
		end
		dex = dex - 1
	end
	-- if #ret["list"] >1 then
		-- if #piperson["#VRB"]>0 then
			-- if (piperson["#VRB"][1] == 2 and piperson["#Plural"][1] == 2) or (piperson["#VRB"][#piperson["#VRB"]] == piperson["#p"]-1 and piperson["#Plural"][#piperson["#Plural"]] == piperson["#p"][1] - 1) then
				-- return ret
			-- else
				-- if (piperson["#VRB"][1] == 2 and piperson["#Singular"][1] == 2) or (piperson["#VRB"][#piperson["#VRB"]] == piperson["#p"]-1 and piperson["#Singular"][#piperson["#Singular"]] == piperson["#p"][1] - 1) then
					-- local repo =""
					-- print([[I know many people in a song of ice and fire who match "]].. persons ..[[".
					-- Did you wish all of them, just some, just one of them or None ?]])  
					-- while( #pipe(repo)["#None"]>0 and #pipe(repo)["#Except"] ==0 )do
						-- repo = io.read()
						-- local repiped = pipe(repo)
						-- if #repiped["#AOT"] >0 then
							-- print ("Well fine!")
							-- return ret
						-- end
						-- if #repiped["#Jone"] >0 then
							-- print("Okay.")
							-- if pipe(repiped:tag2str("#Jone")[1])["#Character"] >0 then
								-- ret["list"] = pipe(repiped:tag2str("#Jone")[1])["#Character"]
							-- else
								-- if pipe(repiped:tag2str("#Jone")[1])["#Person"] >0 then
								
								-- end
							-- end
						-- end
					-- end
				-- end
			-- end
		-- end
	-- end
	return ret
end

function WeddingRetrieval(wedding)
	ret = {}
	ret["list"] ={}
	ret["inwedding"] = 0
	
	weds = pipe(wedding)
	if #weds["#Person"] >0 then
		local who = Whois(weds:tag2str("#Person")[#weds["#Person"]])
		ret["inwedding"] = who["inpersons"] +1
		local woin = 1
		while who["list"][whoin] do
			local current = Bd[Link[who["list"][whoin]][1]]
			local relin = 1
			while current["Relation"][relin] do
				if current["Relation"][relin]["lien"]:find("husband") or current["Relation"][relin]["lien"]:find("wife") then
					ret["list"][#ret["list"] +1 ] = current["Relation"][relin]["Name"]
				end
				relin =relin + 1
			end
			woin = woin + 1
		end
	else
		if #weds["#Possess"] > 0 then
			local poss = PossesWhoRetrieval(weds:tag2str("#Possess")[#weds["#Possess"]])
			local posin = 1
			while poss["list"][posin] do
				local current = Bd[Link[who["list"][posin]][1]]
				local relin = 1
				while current["Relation"][relin] do
					if current["Relation"][relin]["lien"]:find("husband") or current["Relation"][relin]["lien"]:find("wife") then
						ret["list"][#ret["list"] + 1] = current["Relation"][relin]["Name"]
					end
					relin =relin + 1
				end
				posin = posin + 1
			end
		else
			if #weds["#Character"]>0 then
				local charin =1
				while weds:tag2str("#Character")[charin] do
					local current = Bd[Link[weds:tag2str("#Character")[charin]][1]]
					local relin = 1
					while current["Relation"][relin] do
						if current["Relation"][relin]["lien"]:find("husband") or current["Relation"][relin]["lien"]:find("wife") then
							ret["list"][#ret["list"] +1 ] = current["Relation"][relin]["Name"]
						end
						relin =relin+1
					end
					charin = charin + 1
				end
			else
				local current = Bd[Link[weds:tag2str("#Pers")[charin]][1]]
				local relin = 1
				while current["Relation"][relin] do
					if current["Relation"][relin]["lien"]:find("husband") or current["Relation"][relin]["lien"]:find("wife") then
						ret["list"][#ret["list"] +1 ] = current["Relation"][relin]["Name"]
					end
					relin =relin+1
				end
			end
		end
	end
	return ret
end

function PossesWhoRetrieval(pos)
	local ret ={}
	ret["list"] = {}
	ret["inposses"] =0
	local who = {}
	who["inpossess"]= 0
	who["list"] = {}
	local whowat = PossWhoWat(pos)
	who["list"][1] = whowat["who"]
	local wat = whowat["wat"]
	if wat:sub(wat:len())=="s"then
		wat = wat:sub(1, wat:len()-1)
	end
	local child = wat =="child"
	local parent = wat == "parent"
	if #pipe(who["list"][1])["#Possess"]> 0 then
		who = PossesWhoRetrieval(who["list"][1])
		ret["inposses"] =  1 + who["inposses"]
	end
	local j=1
	local i =1
	while who["list"][j] do	
		local whob = who["list"][j]
		print("kek")
		print(whob)
		print(wat)
		while Bd[Link[whob][1]]["Relation"][i] do
			if wat == "children" then
				if (Bd[Link[who][1]]["Relation"][i]["lien"]:find("son") and Bd[Link[whob][1]]["Relation"][i]["lien"]:find("/") > Bd[Link[whob][1]]["Relation"][i]["lien"]:find("son") )
					or (Bd[Link[whob][1]]["Relation"][i]["lien"]:find("daughter") and Bd[Link[whob][1]]["Relation"][i]["lien"]:find("/") > Bd[Link[whob][1]]["Relation"][i]["lien"]:find("daughter") ) then
					if table.concat(ret, " "):find(Bd[Link[whob][1]]["Relation"][i]["Name"]) == nil then
						ret["list"][#ret["list"]+1] = Bd[Link[whob][1]]["Relation"][i]["Name"]
					end
				end
			end
			if wat == "parents" then 
				if (Bd[Link[whob][1]]["Relation"][i]["lien"]:find("father") and Bd[Link[whob][1]]["#Relation"][i]["lien"]:find("/") > Bd[Link[whob][1]]["Relation"][i]["lien"]:find("father") )
					or (Bd[Link[whob][1]]["Relation"][i]["lien"]:find("mother") and Bd[Link[whob][1]]["#Relation"][i]["lien"]:find("/") > Bd[Link[whob][1]]["Relation"][i]["lien"]:find("mother") ) then
					if table.concat(ret, " "):find(Bd[Link[whob][1]]["Relation"][i]["Name"]) == nil then
						ret["list"][#ret["list"]+1] = Bd[Link[whob][1]]["Relation"][i]["Name"]
					end
				end
			else
				if Bd[Link[whob][1]]["Relation"][i]["lien"]:find(wat) then
					if Bd[Link[whob][1]]["Relation"][i]["lien"]:find("/") and Bd[Link[whob][1]]["Relation"][i]["lien"]:find("/") > Bd[Link[whob][1]]["Relation"][i]["lien"]:find(wat) then
						if table.concat(ret, " "):find(Bd[Link[whob][1]]["Relation"][i]["Name"]) == nil then
							ret["list"][#ret["list"]+1] = Bd[Link[whob][1]]["Relation"][i]["Name"]
						end
					else
						if table.concat(ret, " "):find(Bd[Link[whob][1]]["Relation"][i]["Name"]) == nil then
							ret["list"][#ret["list"]+1] = Bd[Link[whob][1]]["Relation"][i]["Name"]
						end
					end
				end
			end
			i= i+ 1
		end
		j = j+1
	end
	print(#ret["list"])
	return ret
end

contextp = nil
print([[Hello, i'm AskA.S.O.I.A.F., your chatbot dedicated to A Song Of Ice And Fire.]])
print([[What can i do for you today ?]])
while quitting ~= true do
	local context = {}
	local interrogation =false
	local Charac = nil
	local poswat = nil
	reply = ""
	base = {}
	answer = io.read()
	piped = pipe(answer:gsub("%p", " %0 "))
	print(piped)
	if #piped["#Character"] == 0 then
		if #piped["#Pers"] == 0 then
			print ("Who are you talking about ?")
		else
			Charac = contextp
		end
	else
		Charac = piped:tag2str("#Character")[1]
		contextp = Charac
	end
	if #piped["#Possess"] == 1 then
		local pos = piped:tag2str("#Possess")[1]
		poswat = PossWhoWat(pos)["wat"]
		reply = pos.." "
		reply = reply .. piped:tag2str("#POS=VRB")[1].." "
	end
	 -- print (Charac)
	if Charac then
		if #piped["#Person"] > 0  then 
			-- if #piped["#Relation"] >0 then
				print(table.concat(piped:tag2str("#Person"), " "))
				local relin = Whois(piped:tag2str("#Person")[#piped["#Person"]])
				local i = 1
				-- print (Charac)
				-- while Bd[Charac]["Relation"][relin]["lien"]:find(poswat) == nil and relin <= #Bd[Charac]["Relation"] do
					-- print(relin)
					-- relin = relin +1 
				-- end
					reply = reply .. table.concat(relin["list"], ", ") .. "."
			-- end
		end
			if #piped["#Aliases"] ~= 0 then
				local ain = 1
				while Bd[Charac]["Aliases"][ain] do
					reply = reply .. Bd[Link[Charac][1]]["Aliases"][ain]["value"].. ", "
					ain = ain +1
				end
			end
		if piped:tag2str("#QuestionMark")[1]:lower() == "what" then
			if #piped["#Titles"]>0 then
				local tin =1
				local tex =""
				if #piped["#POS=VRB"] == #piped["#Present"] then
					tex = "current"
				else
					tex= "former"
				end
				while Bd[Link[Charac][1]]["Titles"][tex][tin] do
					reply = reply .. Bd[Link[Charac][1]]["Titles"][tex][tin]["value"].. ", "
					tin = tin +1
				end
			end
		end
	end
	reply = reply:gsub("( )(%p )", "%2")
	print (reply)
end

print([[I'm glad that we could have a talk.
See you later.
And remember, Winter is Coming.]])
	
