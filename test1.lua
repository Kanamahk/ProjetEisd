pipe = dofile("pipeLine.lua")
require(
Link = dofile("exempleIndexBD.lua")
Bd = dofile("exempleCharacterBD.lua")
quitting = false

function LocFetch(locations)
	local ret = {}
	local locapipe = pipe(locations)
	
end

function PossRetrieval(possess, isPast, isPlur)
	local ret = {}
	local tret =""
	local piposs = pipe(possess)
	local whot = {}
	local who = piposs:tag2str("#Possessor")[1]
	local wat = piposs:tag2str("#Possessed")[1]
	if #pipe(who)["#RelPossess"]>0 then
		whot = PossesWhoRetrieval(who)
	else
		local Chara = nil
		if #pipe(who)["#Possessif"]>0 then
			Chara = Bd[Link[contextp][1]]
		else
			Chara = Bd[Link[who][1]]
		end
		local pipwat = pipe(piposs:tag2str("#Possessed"))
		print(#piposs["#HasPast"])
		if #piposs["#Time"] > 0  then
			print("2")
		elseif #piposs["#Appearance"] >0 then
			print("1")
		elseif #piposs["#HasPast"] > 0 then 
			local tag = ""
			if #piposs["#TimeStamp"]>0 then
				tag = pipwat[2][2]["name"]
			else
				tag = pipwat[1][2]["name"]
			end	
			if isPast == true or (#pipwat:tag2str("#TimeStamp")==1 and pipwat:tag2str("#TimeStamp")[1] == "former") then
				for i = 1, #Chara[tag:sub(tag:find("#")+1)]["former"], 1 do
					ret[#ret+1] = Chara[tag:sub(tag:find("#")+1)]["former"][i]["value"]
				end
			elseif isPast == false or (#pipwat:tag2str("#TimeStamp")==1 and pipwat:tag2str("#TimeStamp")[1] == "current") then
				for i = 1, #Chara[tag:sub(tag:find("#")+1)]["current"], 1 do
					ret[#ret+1] = Chara[tag:sub(tag:find("#")+1)]["current"][i]["value"]
				end
			elseif #pipwat:tag2str("#TimeStamp")>1 then 
				for i = 1, #Chara[tag:sub(tag:find("#")+1)]["former"], 1 do
					ret[#ret+1] = Chara[tag:sub(tag:find("#")+1)]["former"][i]["value"]
				end
				for i = 1, #Chara[tag:sub(tag:find("#")+1)]["current"], 1 do
					ret[#ret+1] = Chara[tag:sub(tag:find("#")+1)]["current"][i]["value"]
				end
			end
		else
			local tag = pipwat[1][2]["name"]
			for i=1, #Chara[tag:sub(tag:find("#")+1)], 1 do
				ret[#ret+1] = Chara[tag:sub(tag:find("#")+1)][i]["value"]
			end
		end
		if isPlur == true then
			return table.concat(ret, ", ")
		else
			
		end
	end
end

-- Returns the Levenshtein distance between the two given strings
function string.levenshtein(str1, str2)
	local len1 = string.len(str1)
	local len2 = string.len(str2)
	local matrix = {}
	local cost = 0
	
        -- quick cut-offs to save time
	if (len1 == 0) then
		return len2
	elseif (len2 == 0) then
		return len1
	elseif (str1 == str2) then
		return 0
	end
	
        -- initialise the base matrix values
	for i = 0, len1, 1 do
		matrix[i] = {}
		matrix[i][0] = i
	end
	for j = 0, len2, 1 do
		matrix[0][j] = j
	end
	
        -- actual Levenshtein algorithm
	for i = 1, len1, 1 do
		for j = 1, len2, 1 do
			if (str1:byte(i) == str2:byte(j)) then
				cost = 0
			else
				cost = 1
			end
			
			matrix[i][j] = math.min(matrix[i-1][j] + 1, matrix[i][j-1] + 1, matrix[i-1][j-1] + cost)
		end
	end
	
        -- return the last value - this is the Levenshtein distance
	return matrix[len1][len2]
end

function PossWhoWat(pos)
	local ret = {}
	print(pos)
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
			print(sif)
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
	if #piped["#WhatQuestion"] >0 then
		local pos = piped:tag2str("#Possess")[1]
		poswat = PossWhoWat(pos)["wat"]
		reply = pos.." "
		reply = reply .. piped:tag2str("#VRB")[1].." ".. PossRetrieval(pos,#piped["#Past"]>0,#piped["#Plural"]>0)
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
	end
	reply = reply:gsub("( )(%p )", "%2")
	print (reply)
end

print([[I'm glad that we could have a talk.
See you later.
And remember, Winter is Coming.]])
	
