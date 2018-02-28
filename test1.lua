pipe = dofile("pipeLine.lua")
Link = dofile("exempleIndexBD.lua")
Bd = dofile("CharacterBD.lua")
quitting = false
math.randomseed(os.time())

function LocFetch(locations)
	local ret = {}
	local locapipe = pipe(locations)
	
end
--returns what is wanted from the possess pattern
function PossRetrieval(possess, isPast, isPlur)
	local ret = {}
	local tret =""
	if possess then
		local piposs = pipe(possess)
		local whot = {}
		local who = piposs:tag2str("#Possessor")[1]
		local wat = piposs:tag2str("#Possessed")[1]
		if #pipe(who)["#RelPossess"]>0 then
			ret["sevChar"] = true
			tret = ": "
			whot = PossesWhoRetrieval(who)
			for i=1, #whot["list"], 1 do
				which = {}
				tret = tret .. whot["list"][i] .."; "
				local Chara = Bd[Link[whot["list"][i]][1]]
				local pipwat = pipe(piposs:tag2str("#Possessed"))
				if #piposs["#Time"] > 0  then
					local tag = pipwat[1][2]["name"]
					local tag2 = pipwat[2][2]["name"]
					which[#which+1] = Charac[tag:sub(tag:find("#")+1)][tag2:sub(tag2:find("#")+1)]
				elseif #piposs["#Appearance"] >0 then
					print("1")
				elseif #piposs["#HasPast"] > 0 then 
					local tag = ""
					if #piposs["#Timestamp"]>0 then
						tag = piposs[piposs["#Possessed"][1][2]][2]["name"]
					else
						tag = piposs[piposs["#Possessed"][1][1]][2]["name"]
					end	
					if (#piposs:tag2str("#Timestamp")==1 and piposs:tag2str("#Timestamp")[1] == "former") or isPast == true then
						for i = 1, #Chara[tag:sub(tag:find("#")+1)]["former"], 1 do
							ret[#ret+1] = Chara[tag:sub(tag:find("#")+1)]["former"][i]["value"]
						end
					elseif (#piposs:tag2str("#Timestamp")==1 and piposs:tag2str("#Timestamp")[1] == "current") then
						for i = 1, #Chara[tag:sub(tag:find("#")+1)]["current"], 1 do
							ret[#ret+1] = Chara[tag:sub(tag:find("#")+1)]["current"][i]["value"]
						end
					elseif #piposs:tag2str("#Timestamp")>1 then 
						-- ret[#ret+1] = "former"
						for i = 1, #Chara[tag:sub(tag:find("#")+1)]["former"], 1 do
							ret[#ret+1] = Chara[tag:sub(tag:find("#")+1)]["former"][i]["value"]
						end
						-- ret[#ret+1] = "current"
						for i = 1, #Chara[tag:sub(tag:find("#")+1)]["current"], 1 do
							ret[#ret+1] = Chara[tag:sub(tag:find("#")+1)]["current"][i]["value"]
						end
					end
				else
					local tag = pipwat[1][2]["name"]
					for i=1, #Chara[tag:sub(tag:find("#")+1)], 1 do
						which[#which+1] = Chara[tag:sub(tag:find("#")+1)][i]["value"]
					end
				end
				if isPlur == true then
					if #which>0 then
						tret= tret.. table.concat(which, ", ") 
					else
						tret = tret.. "UNKNOWN"
					end
					tret = tret.. "\n"
				else
					tret = tret .. which[math.random(#which)]
				end
			end
		else
			ret["sevChar"] = false
			local Chara = nil
			if #pipe(who)["#Possessif"]>0 then
				Chara = Bd[Link[contextp][1]]
			else
				Chara = Bd[Link[who][1]]
			end
			local pipwat = pipe(piposs:tag2str("#Possessed"))
			if #piposs["#Time"] > 0  then
				local tag = piposs[piposs["#Possessed"][1][1]][2]["name"]
				local tag2 = piposs[piposs["#Possessed"][1][2]][2]["name"]
				for i=1, #Chara[tag:sub(2)][tag2:sub(2)], 1 do
					ret[#ret+1] = Chara[tag:sub(2)][tag2:sub(2)][i]["Period"]
					ret[#ret+1] = Chara[tag:sub(2)][tag2:sub(2)][i]["value"]
				end
			elseif #piposs["#Appearance"] >0 then
				local rr =  "Eyes : "
				if #Chara["Appearance"]["Traits"]["Eyes"] == 0 then 
					rr  = rr.."UNKNOWN"
				else
					for i =1, #Chara["Appearance"]["Traits"]["Eyes"], 1 do
						rr = rr..Chara["Appearance"]["Traits"]["Eyes"][i]["value"]..", "
					end
				end
				rr= rr.." Skin: "
				if #Chara["Appearance"]["Traits"]["Skin"] == 0 then 
					rr  = rr.."UNKNOWN"
				else
					for i =1, #Chara["Appearance"]["Traits"]["Skin"], 1 do
						rr = rr..Chara["Appearance"]["Traits"]["Skin"][i]["value"]..", "
					end
				end
				rr= rr..", Hair : "
				if #Chara["Appearance"]["Traits"]["Hair"]==0 then
					rr = rr .."UNKNOWN"
				else
					for i =1, #Chara["Appearance"]["Traits"]["Hair"], 1 do
						rr = rr..Chara["Appearance"]["Traits"]["Hair"][i]["value"]..", "
					end
				end
				ret[#ret +1] = rr
			elseif #piposs["#HasPast"] > 0 then 
				local tag = ""
				local timeTag = {}
				if #piposs["#Timestamp"]>0 then
					tag = piposs[piposs["#Possessed"][1][2]][2]["name"]
					for k =1, #piposs:tag2str("#Timestamp"), 1 do
						timeTag[#timeTag+1] = piposs:tag2str("#Timestamp")[k]
					end
				else
					tag = piposs[piposs["#Possessed"][1][1]][2]["name"]
				end	
				if (#piposs:tag2str("#Timestamp")==1 and piposs:tag2str("#Timestamp")[1] == "former") or (isPast == true and #piposs:tag2str("#Timestamp")==0)then
					for i = 1, #Chara[tag:sub(2)]["former"], 1 do
						ret[#ret+1] = Chara[tag:sub(2)]["former"][i]["value"]
					end
				elseif (#piposs:tag2str("#Timestamp")==1 and piposs:tag2str("#Timestamp")[1] == "current") or (isPast == false and #piposs:tag2str("#Timestamp")==0)then
					for i = 1, #Chara[tag:sub(2)]["current"], 1 do
						ret[#ret+1] = Chara[tag:sub(2)]["current"][i]["value"]
					end
				elseif #piposs:tag2str("#Timestamp")==1 then
					for i = 1, #Chara[tag:sub(2)]["current"], 1 do
						ret[#ret+1] = Chara[tag:sub(2)]["current"][i]["value"]
					end
				elseif #piposs:tag2str("#Timestamp")>1 then 
					for k=1, #timeTag, 1 do	
						for i = 1, #Chara[tag:sub(2)][timeTag[k]], 1 do
							ret[#ret+1] = Chara[tag:sub(2)][timeTag[k]][i]["value"]
						end
					end
				end
			else
				local tag = pipwat[1][2]["name"]
				if Chara[tag:sub(2)] then
					if Chara[tag:sub(2)]["value"] then
						ret[#ret +1] = Chara[tag:sub(2)]["value"]
					elseif #Chara[tag:sub(2)]>0 and Chara[tag:sub(2)][1] then
						for i=1, #Chara[tag:sub(2)], 1 do
							ret[#ret+1] = Chara[tag:sub(2)][i]["value"]
						end
					else
						ret[#ret+1] = Chara[tag:sub(2)]
					end
				end
			end
			if isPlur == true then
				if #ret > 0 then
					return table.concat(ret, ", ")
				else
					return "UNKNOWN"
				end
			else
				if #ret>0 then
					return ret[math.random(#ret)]
				else
					return "UNKNOWN"
				end
			end
		end
	else
	return ""
	end
end

--returns the location, the place where something happenned
function LocationRetrieval(location)
	local pipedloc = pipe(location)
	local ret = ""
	local who = pipedloc:tag2str("#Pers")[1]
	local whos ={}
	if #pipe(who)["#Person"] >0 then
		whos = Whois(who)
	end
	if #whos >0 then
	
	else 
		local tag = pipedloc[pipedloc["#Action"][1][1]][2]["name"]
		tag = tag:sub(2)
		ret = Bd[Link[who][1]][tag]["Place"]["value"]
	end
	return ret
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
		if #piperson["#RelPossess"] >0 then
			local posin = 1
			parc = 1
			local p = length
			while piperson["#Posess"][parc] do 
				if p > piperson["#RelPossess"][parc][1] then 
					p = piperson["#RelPossess"][parc][1]
					posin = parc
				end
				parc = parc +1
			end
			local poss = piperson:tag2str("#RelPossess")[1]
			prec = persons:sub(persons:find(poss) + poss:len())
			whos = PossesWhoRetrieval(poss)
			--print(#whos["list"])
			-- print(table.concat(whos["list"], ", "))
		end
		if #whos["list"] == 1 then
			ret["list"][#ret["list"]+1] = whos["list"][1]
		else
			if #whos["list"] > 1 then
				if #pipe(prec)["#Person"]>0 then
					percs = Whois(pipe(prec)["#Person"][#pipe(prec)["#Person"]])
					ret["inpersons"] = ret["inpersons"] + 1 + percs["inpersons"]
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
				ret = whos
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
	local pipos = pipe(pos)
	ret["list"] = {}
	ret["inposses"] =0
	local who = {}
	who["inpossess"]= 0
	who["list"] = {}
	who["list"][1] = pipos:tag2str("#Possessor")[1]
	local wat = pipos:tag2str("#Relation")[1]
	-- if wat:sub(wat:len())=="s"then
		-- wat = wat:sub(1, wat:len()-1)
	-- end
	local child = wat =="child"
	local parent = wat == "parent"
	if #pipe(who["list"][1])["#Possess"]> 0 then
		who = PossesWhoRetrieval(who["list"][1])
		ret["inposses"] =  1 + who["inposses"]
	end
	local j=1
	local i =1
	print(wat)
	while who["list"][j] do	
		local whob = who["list"][j]
		if #pipe(whob)["#Possessif"] == 1 then whob = contextp end
		while Bd[Link[whob][1]]["Relation"][i] do
			if wat == "children" then
				if (Bd[Link[who][1]]["Relation"][i]["lien"]:find("son") and Bd[Link[whob][1]]["Relation"][i]["lien"]:find("/") > Bd[Link[whob][1]]["Relation"][i]["lien"]:find("son") )
					or (Bd[Link[whob][1]]["Relation"][i]["lien"]:find("child") and Bd[Link[whob][1]]["Relation"][i]["lien"]:find("/") > Bd[Link[whob][1]]["Relation"][i]["lien"]:find("daughter") )
					or (Bd[Link[whob][1]]["Relation"][i]["lien"]:find("daughter") and Bd[Link[whob][1]]["Relation"][i]["lien"]:find("/") > Bd[Link[whob][1]]["Relation"][i]["lien"]:find("daughter") )
					then
					if table.concat(ret, " "):find(Bd[Link[whob][1]]["Relation"][i]["Name"]) == nil then
						ret["list"][#ret["list"]+1] = Bd[Link[whob][1]]["Relation"][i]["Name"]
					end
				end
			end
			if wat == "parents" then 
				if (Bd[Link[whob][1]]["Relation"][i]["lien"]:find("father") and Bd[Link[whob][1]]["Relation"][i]["lien"]:find("/") > Bd[Link[whob][1]]["Relation"][i]["lien"]:find("father") )
					or (Bd[Link[whob][1]]["Relation"][i]["lien"]:find("mother") and Bd[Link[whob][1]]["Relation"][i]["lien"]:find("/") > Bd[Link[whob][1]]["Relation"][i]["lien"]:find("mother") ) then
					if table.concat(ret, " "):find(Bd[Link[whob][1]]["Relation"][i]["Name"]) == nil then
						ret["list"][#ret["list"]+1] = Bd[Link[whob][1]]["Relation"][i]["Name"]
					end
				end
			elseif Bd[Link[whob][1]]["Relation"][i]["lien"]:find(wat) then
			print(whob)
				if Bd[Link[whob][1]]["Relation"][i]["lien"]:find("/") and Bd[Link[whob][1]]["Relation"][i]["lien"]:find("/") > Bd[Link[whob][1]]["Relation"][i]["lien"]:find(wat) then
					if table.concat(ret, " "):find(Bd[Link[whob][1]]["Relation"][i]["Name"]) == nil then
						ret["list"][#ret["list"]+1] = Bd[Link[whob][1]]["Relation"][i]["Name"]
					end
				elseif table.concat(ret, " "):find(Bd[Link[whob][1]]["Relation"][i]["Name"]) == nil then
					ret["list"][#ret["list"]+1] = Bd[Link[whob][1]]["Relation"][i]["Name"]						
				end
			end
			i= i+ 1
		end
		j = j+1
	end
	print(table.concat(ret["list"], ", "))
	return ret
end

function GenderSynonym(gender)
	if gender == "male" or gender == "man" or gender =="men" or gender =="boy" then
		return "male"
	elseif gender == "female" or gender == "woman" or gender == "women" or gender ==  "girl" then
		return "female"
	end
	return gender
end

function openWho(whopen)
	local tag =nil
	local ret ={}
	local value =""
	if whopen then
		local pipopen = pipe(whopen)
		if #pipopen["#Time"] >0 then
			tag = pipopen[pipopen["#Time"][1][1]][2]["name"]:sub(2)
			tag2 = pipopen[pipopen["#Time"][1][2]][2]["name"]
			value = pipopen:tag2str(tag2)[1]
			for i=1, #Bd, 1 do
				if tag2 == "#Houses" then
					if Bd[i][tag]["#House"]["value"] == value then 
						ret[#ret+1] = Bd[i]["Name"]["Firstname"]["value"] .." "..Bd[i]["Name"]["Surname"]["value"]
					end
				elseif #Bd[i][tag][tag2]>0 then
					for j=1, #Bd[i][tag][tag2],1 do
						if #Bd[i][tag][tag2][j]["value"] == value then
							
							ret[#ret+1] = Bd[i]["Name"]["Firstname"]["value"] .." "..Bd[i]["Name"]["Surname"]["value"]
						end
					end
				end
			end
		elseif #pipopen["#HasPast"] >0then
			local timeTag= {}
			tag = pipopen[pipopen["#HasPast"][1][2]][2]["name"]
			value = pipoen:tag2str(tag)[1]
			if #pipopen["#Timestamp"]>0 then
				for k =1, #pipopen:tag2str("#Timestamp"), 1 do
					local tim = pipopen:tag2str("#Timestamp")[k]
					if tim:lower():find("former") then
						timeTag[#timeTag+1] = "former"
					elseif tim:lower():find("current") then
						timeTag[#timeTag+1] = "current"
					else tim:lower():find("claim")
						timeTag[#timeTag+1] = "claim"
					end
				end
			end
			if tag:sub(tag:len()) == "s" then
				tag = tag:sub(2, tag:len()-1)
			else
				tag = tag:sub(2).."s"
			end
			if #timeTag == 0 and #pipopen["#Past"]==1 then
				for i=1, #Bd, 1 do 
					for j=1, #Bd[i][tag]["former"], 1 do
						if #Bd[i][tag]["former"][j]["value"] == value then
							ret[#ret+1] = Bd[i]["Name"]["Firstname"]["value"] .." "..Bd[i]["Name"]["Surname"]["value"]
						end
					end
				end
			elseif #timeTag == 0 and #pipopen["#Present"]==1 then
				for i=1, #Bd, 1 do 
					for j=1, #Bd[i][tag]["current"], 1 do
						if #Bd[i][tag]["current"][j]["value"] == value then
							ret[#ret+1] = Bd[i]["Name"]["Firstname"]["value"] .." "..Bd[i]["Name"]["Surname"]["value"]
						end
					end
				end
			else
				for k =1 , #timeTag, 1 do
					for i=1, #Bd, 1 do 
						for j=1, #Bd[i][tag][timeTag[k]], 1 do 
							if #Bd[i][tag][timeTag[k]][j]["value"] == value then
								ret[#ret+1] = Bd[i]["Name"]["Firstname"]["value"] .." "..Bd[i]["Name"]["Surname"]["value"]
							end
						end
					end
				end
			end
		elseif #pipopen["#Descr"]>0then
		
		else
			tag = pipopen[pipopen["#ActWho"][1][2]][2]["name"]
			value = pipopen:tag2str(tag)[1]
			if tag:sub(tag:len()) == "s" then
				tag = tag:sub(2, tag:len()-1)
			else
				tag = tag:sub(2).."s"
			end
			value = GenderSynonym(value)
			for i=1, #Bd, 1 do
				if Bd[i][tag] then
					if Bd[i][tag]["value"] then
						if Bd[i][tag]["value"] == value then
							ret[#ret+1] = Bd[i]["Name"]["Firstname"]["value"] .." "..Bd[i]["Name"]["Surname"]["value"]
						end
					elseif #Bd[i][tag]>0 and Bd[i][tag][1] then
						for j=1, #Bd[i][tag], 1 do
							if Bd[i][tag][j]["value"] == value then
								ret[#ret+1] = Bd[i]["Name"]["Firstname"]["value"] .." "..Bd[i]["Name"]["Surname"]["value"]
							end
						end
					elseif Bd[i][tag]== value then
						ret[#ret+1] = Bd[i]["Name"]["Firstname"]["value"] .." "..Bd[i]["Name"]["Surname"]["value"]
					end
				end
			end
		end
	else
		return "UNKNOWN"
	end
		return table.concat(ret, ", ")
end

function RelpossesSimpleRetrieve (pos)
	local pipedRel = pipe(pos)
	local relation = pipedRel:tag2str("#Relation")[1]
	local ret = {}
	local chara = nil
	if #pipedRel["#Possessif"]>0 then
		chara = contextp
	else
		chara = pipedRel:tag2str("#Possessor")[1]
	end
	for i =1, #Bd[Link[chara][1]]["Relation"],1 do
		if (Bd[Link[chara][1]]["Relation"][i]["lien"]:find(relation) and Bd[Link[chara][1]]["Relation"][i]["lien"]:find("/") == nil) 
		or (Bd[Link[chara][1]]["Relation"][i]["lien"]:find("/") and Bd[Link[chara][1]]["Relation"][i]["lien"]:find(relation)
			and Bd[Link[chara][1]]["Relation"][i]["lien"]:find(relation)< Bd[Link[chara][1]]["Relation"][i]["lien"]:find("/")) then
			ret[#ret+1] = Bd[Link[chara][1]]["Relation"][i]["Name"]
		end
	end
	if #ret == 0 then
	ret[1]="I don't know about this information"
	end
	return ret
end

function PossesMultiRel(relpossess, piped)
	local repList = {}
	local relpiposess = pipe(relpossess)
	local enums = relpipossess:tag2str("#EnumRel")[ #relpipossess["#EnumRel"] ]					
	local start = relpossess:sub(1, relpossess:find(enums) -1)
	local ending = relpossess:sub(relpossess:find(enums) + enums:len())
	for i=1, #relpiposess["#Relation"], 1 do
		local relation = relpiposess:tag2str("#Relation")[i]
		local question = start .. relation .. ending
		local actrep = relpossess
		if relation ==	"children" then
			local perlist = {} 
			perlist[#perlist + 1] = table.concat(RelpossesSimpleRetrieve(start .. "child"..ending), ", ")
			perlist[#perlist + 1] = table.concat(RelpossesSimpleRetrieve(start .. "daughter"..ending), ", ")
			perlist[#perlist + 1] = table.concat(RelpossesSimpleRetrieve(start .. "son"..ending), ", ")
			repList[#repList + 1] = actrep .." "..  table.concat(perlist, ", ") 
		elseif relation == "parents" or relation == "parent" then
			local perlist = {}
			perlist[#perlist + 1] = table.concat(RelpossesSimpleRetrieve(start .. "child"..ending), ", ")
			perlist[#perlist + 1] = table.concat(RelpossesSimpleRetrieve(start .. "daughter"..ending), ", ")
			repList[#repList + 1] = actrep .." ".. table.concat(perlist, ", ")
		else
			local perlist = RelpossesSimpleRetrieve(start .. relation .. ending)
			if #perlist > 1  and #piped["#Past"] > 0 then
				actrep = actrep .. " " .. "were"
			elseif #perlist > 1 and #piped["#Present"] > 0 then
				actrep = actrep .. " " .. "are"
			elseif #piped["#Past"] >0 then
				actrep = actrep .. " " .. "was"
			else
				actrep = actrep .. " " .. "is"
			end
			repList[#repList +1] = actrep .. " " .. table.concat(perlist, ", ")
		end
	end
	return repList
end

function RelPossessRetrieve (poss)
	local pipedoss = pipe(poss)
	for i=1, #pipedoss["#RelPossess"], 1 do
		-- local 
	end
end

contextp = nil
bounce = false;
contextq =	{}
contextq["piped"] = nil
contextq["str"] = nil
print([[Hello, i'm AskA.S.O.I.A.F., your chatbot dedicated to A Song Of Ice And Fire.]])
print([[What can i do for you today ?]])
while quitting ~= true do
	local context = {}
	local interrogation =false
	local Charac = nil
	reply = ""
	local vrb =""
	if bounce == false then
		answer = io.read():gsub("%p", " %0 ")
	else
		bounce = false
	end
	piped = pipe(answer)
	print(piped)
	quitting = #piped["#Quit"]>0
	if #piped["#ActWho"]>0 then
		local ply = openWho(piped:tag2str("#ActWho")[1])
		
		if ply then
			reply = ply
		else
			reply ="This question doesn't make any sense"
		end
	elseif #piped["#Character"] == 0 then
		if #piped["#Pers"] == 0 then
			print ("Who are you talking about ?")
		else
			Charac = contextp
		end
	else
		Charac = piped:tag2str("#Character")[1]
		contextp = Charac
	end
	if quitting == false then
		if #piped["#VRB"]>0 then
			vrb = piped:tag2str("#VRB")[1]
		else
			vrb = contextq["piped"]:tag2str("#VRB")[1]
		end
	end
	if #piped["#LoQuestion"]>0 then
		reply = LocationRetrieval(piped:tag2str("#LoQuestion")[1])
		if reply == nil then 
			reply = "This question doesn't make any sense"
		end
		contextq["piped"] = piped
		contextq["str"] = answer
	elseif #piped["#WhatQuestion"] >0 then
		for i=1, #piped["#Possess"], 1 do
			local pos = piped:tag2str("#Possess")[i]
			local sors ={}
			sors[1] = pipe(pos):tag2str("#Possessor")[1]
			local begin = pos:sub(1, pos:find(sors[1]) -1 )
			if #pipe(pos)["#PossEnum"] >0 then
				local popo = pipe(pos)
				for j=1, #popo["#PossInEnum"], 1 do
					sors[#sors +1] = popo:tag2str("#PossInEnum")[j]
				end
			end
			local final = pos:sub(pos:find(sors[#sors]) + sors[#sors]:len())
			local temp = sors
			sors = {}
			for j=1, #temp, 1 do
				if #pipe(temp[j])["#RelPossess"]>0 then
					local piptreat = pipe(temp[j])
					local character = {}
					for v=1, #piposor["#RelPossess"], 1 do
						if #character ==0 then
							local actpos = piposor:tag2str("#RelPossess")[v]
							if #pipe(actpos)["#Relation"]>1 then
								repList = PossesMultiRel(actpos, piped)
								for k=1, #repList, 1 do
									print (repList[k])
									local re = pipe(repList[k])
									for n = 2, #re["#Character"], 1 do
										character[#character+1] = re:tag2str("#Character")[n]
									end
								end
							else
								character = RelPossessRetrieve(actpos)
							end
						else
							local charaparc = character
							character = {}
							local actpos = piposor:tag2str("#RelPossess")[v]
							local soremplace = piposor:tag2str("#Possessor")[#piposor["#Possessor"]]
							local start = actpos:sub(1,actpos:find(soremplace)-1)
							local ending = actpos:sub(actpos:find(soremplace) + soremplace:len())
							for k = 1, #charaparc, 1 do
								local actchar = charaparc[k]
								local treat = start .. actchar .. ending
								if #pipe(treat)["#Relation"] >1 then
									repList = PossesMultiRel(treat, piped)
									for l=1, #repList, 1 do
										print(repList[l])
										local re = pipe(repList[l])
										for n=2, #re["#Character"], 1 do
											character[#character+1] = re:tag2str("#Character")[n]
										end
									end
								else
									local cra = RelpossesSimpleRetrieve(treat)
									for n=1, #cra, 1 do
										character[#character] = cra[n]
									end
								end
							end
						end
					end
					for v = 1, #character, 1 do
						sors[#sors+1]=character[v]
					end
				else
					sors[#sors+1] = temp[j]
				end
			end
			for j=1, #sors, 1 do
				local atrib = begin .. sors[j] ..final
				local buts = {}
				buts[1] = pipe(atrib):tag2str("#Possessed")[1]
				if #pipe(atrib)["#EnumAt"] > 0 then
					local popo = pipe(atrib)
					for k=1, #popo["#EnumAt"], 1 do
						buts[#buts +1] = popo:tag2str("#EnumAt")[k]
					end
				end
				local start = atrib:sub(1, atrib:find(buts[1])-1)
				local ending = atrib:sub(atrib:find(buts[#buts]) + buts[#buts]:len())
				for k=1, #buts, 1 do
					local trep = PossRetrieval(start .. buts[k] .. ending,#piped["#Past"]>0,#piped["#Plural"]>0)
					if trep == "UNKNOWN" then
						print( "I don't know about this information, sorry")
					elseif trep == "" then 
						print( "This question doesn't make any sense")
					else
						print( start..buts[k]..ending .. " " .. piped:tag2str("#VRB")[1] .. " " .. trep)
					end
				end
			end
		end
		contextq["piped"] = piped
		contextq["str"] = answer
	elseif #piped["#Person"] > 0  then 
		if #piped["#Wed"] >0 then
			
		elseif #piped["#RelPossess"] == 1 then
				local repattern = nil
				local relpiposess = pipe(piped:tag2str("#RelPossess")[1])
				if #relpiposess["#PossEnum"] > 0 then
					local sors = {}
					sors[1] = relpiposess:tag2str("#Possessor")[1]
					for i=1, #relpiposess["#PossEnum"], 1 do
						sors[#sors+1] = relpiposess:tag2str("#PossInEnum")[i]
					end
					local rel = piped:tag2str("#RelPossess")[1]
					local start = rel:sub(1, rel:find(sors[1])-1)
					local ending = rel:sub(rel:find(sors[#sors])+sors[#sors]:len())
					for i=1, #sors, 1 do
						local actpossess = start .. sors[i] .. ending
						if #pipe(actpossess)["#Relation"] > 1 then
							print( table.concat(PossesMultiRel(actpossess,piped), ".\n"))
						else
							print( actpossess ..": ".. table.concat(RelpossesSimpleRetrieve(actpossess), ", "))
						end
					end
				else
					if #relpiposess["#Relation"] > 1 then
						print( table.concat(PossesMultiRel(piped:tag2str("#RelPossess")[1],piped), ".\n"))
					else
						print( piped:tag2str("#RelPossess")[1] ..": ".. table.concat(RelpossesSimpleRetrieve(relpiposess), ", "))
					end
				end
		 elseif #piped["#RelPossess"] > 1 then 
			local repList = {}
			for i= #piped["#RelPossess"], 1, -1 do 
				local gloposs = piped:tag2str("#RelPossess")[i]
				local sors ={}
				sors[1] = piped:tag2str("#Possessor")[i]
				local begin = gloposs:sub(1, gloposs:find(sors[1])-1)
				if #pipe(gloposs)["#PossEnum"]>0 then
					local glopiped = pipe(gloposs)
					for z =1, #glopiped["#PossEnum"], 1 do
						sors[#sors+1] = glopiped:tag2str("#PossInEnum")[z]
					end
				end
				local final = gloposs:sub(gloposs:find(sors[#sors]) + sors[#sors]:len())
				for z =1 , #sors, 1 do
					local poss = begin.. sors[z] ..final
					local possor = sors[z]
					local piposor = pipe(possor)
					if #piposor["#RelPossess"] >1 then
						local character = {}
						for j=1, #piposor["#RelPossess"], 1 do
							if #character ==0 then
								local actpos = piposor:tag2str("#RelPossess")[j]
								if #pipe(actpos)["#Relation"]>1 then
									repList = PossesMultiRel(actpos, piped)
									for k=1, #repList, 1 do
										print (repList[k])
										local re = pipe(repList[k])
										for n = 2, #re["#Character"], 1 do
											character[#character+1] = re:tag2str("#Character")[n]
										end
									end
								else
									character = RelPossessRetrieve(actpos)
								end
							else
								local charaparc = character
								character = {}
								local actpos = piposor:tag2str("#RelPossess")[j]
								local soremplace = piposor:tag2str("#Possessor")[#piposor["#Possessor"]]
								local start = actpos:sub(1,actpos:find(soremplace)-1)
								local ending = actpos:sub(actpos:find(soremplace) + soremplace:len())
								for k = 1, #charaparc, 1 do
									local actchar = charaparc[k]
									local treat = start .. actchar .. ending
									if #pipe(treat)["#Relation"] >1 then
										repList = PossesMultiRel(treat, piped)
										for l=1, #repList, 1 do
											print(repList[l])
											local re = pipe(repList[l])
											for n=2, #re["#Character"], 1 do
												character[#character+1] = re:tag2str("#Character")[n]
											end
										end
									else
										local cra = RelpossesSimpleRetrieve(treat)
										for n=1, #cra, 1 do
											character[#character] = cra[n]
										end
									end
								end
							end
						end
						i = i-#piposor["#RelPossess"] +1
					else
						if #pipe(poss)["#Relation"] >1 then
							print (table.concat(RelPossessRetrieve(poss, piped), ".\n"))
						else
							print (poss .. ": ".. table.concat(RelpossesSimpleRetrieve(poss), ", ").. ".")
						end
					end
					
				end
			end
		 end
	elseif contextq["piped"] and contextq["str"] and piped["#Quit"] == 0 then
		local pipeq = contextq["piped"]
		local pers = piped:tag2str("#Character")[1]
		answer =contextq["str"]:sub(1,contextq["str"]:find(pipeq:tag2str("#Pers")[1])-1 )..pers..contextq["str"]:sub(contextq["str"]:find(pipeq:tag2str("#Pers")[1])+pipeq:tag2str("#Pers")[1]:len())
		bounce = true
	end
	if bounce == false then
		reply = reply:gsub("( )(%p )", "%2")
		--print (reply..".")
	end
end

print([[I'm glad that we could have a talk.
See you later.
And remember, Winter is Coming.]])
	
