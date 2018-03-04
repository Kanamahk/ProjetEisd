pipe = dofile("pipeLine.lua")
Link = dofile("exempleIndexBD.lua")
Bd = dofile("CharacterBD.lua")
quitting = false
math.randomseed(os.time())

retorq={
		"What else can I do for you?",
		"What more do you want ?",
		"What else?",
		"Is That all?",
}

function AnyToTimestamp(str)
	local transform
	if str == "current" or str == "currently" or str == "Current" then
		transform = current
	elseif str == "former" or str == "formerly" or str == "Former" then
		tranform = "former"
	else
		tranform = "claim"
	end
	return tranform
end

--returns what is wanted from the possess pattern
function PossRetrieval(possess, isPast)
	local ret = {}
	local tret =""
	if possess then
		local piposs = pipe(possess)
		local whot = {}
		local who = piposs:tag2str("#Possessor")[1]
		local wat = piposs:tag2str("#Possessed")[1]
		local continue = true
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
		elseif #piposs["#Physical"] >0 then
			if #piposs["#Appearance"] >0 then
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
			else
				local colordect =""
				local tag = piposs[piposs["#Physical"][1][1]][2]["name"]
				if Chara["Appearance"]["Traits"][tag:sub(2)] then
					for i=1, #Chara["Appearance"]["Traits"][tag:sub(2)], 1 do
						colordect = Chara["Appearance"]["Traits"][tag:sub(2)][i]["value"]
						if #piposs["#Colors"] >0 and #pipe(colordect)["#Color"] > 0 then
							ret[#ret + 1] = colordect
						else
							ret[#ret + 1] = colordect
						end
					end
				end
			end
		elseif #piposs["#HasPast"] > 0 then 
			local tag = ""
			local timeTag = {}
			if #piposs["#Timestamp"]>0 then
				tag = piposs[piposs["#Possessed"][1][2]][2]["name"]
				for k =1, #piposs:tag2str("#Timestamp"), 1 do
					local sform = piposs:tag2str("#Timestamp")[k]
					timeTag[#timeTag+1] = AnyToTimestamp(sform)
				end
			else
				tag = piposs[piposs["#Possessed"][1][1]][2]["name"]
			end	
			if (#piposs:tag2str("#Timestamp")==1 and (piposs:tag2str("#Timestamp")[1]:lower() == "former" or piposs:tag2str("#Timestamp")[1]:lower() == "formerly") )or (isPast == true and #piposs:tag2str("#Timestamp")==0)then
				for i = 1, #Chara[tag:sub(2)]["former"], 1 do
					ret[#ret+1] = Chara[tag:sub(2)]["former"][i]["value"]
				end
			elseif (#piposs:tag2str("#Timestamp")==1 and( piposs:tag2str("#Timestamp")[1]:lower() == "current" or piposs:tag2str("#Timestamp")[1]:lower() == "currently")) or (isPast == false and #piposs:tag2str("#Timestamp")==0)then
				for i = 1, #Chara[tag:sub(2)]["current"], 1 do
					ret[#ret+1] = Chara[tag:sub(2)]["current"][i]["value"]
				end
			elseif #piposs:tag2str("#Timestamp")==1 then
				for i = 1, #Chara[tag:sub(2)]["claim"], 1 do
					ret[#ret+1] = Chara[tag:sub(2)]["claim"][i]["value"]
				end
			elseif #piposs:tag2str("#Timestamp")>1 then 
				if possess:find(" or ") then
					local chosen = timeTag[math.random(#timeTag)]
					for i=1, #Chara[tag:sub(2)][chosen], 1 do
						ret[#ret +1] = Chara[tag:sub(2)][chosen][i]["value"]
					end
				else
					for k=1, #timeTag, 1 do	
						for i = 1, #Chara[tag:sub(2)][timeTag[k]], 1 do
							ret[#ret+1] = Chara[tag:sub(2)][timeTag[k]][i]["value"]
						end
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
	end
	return ret
end

--returns the location, the place where something happenned
function LocationRetrieval(location)
	local pipedloc = pipe(location)
	local ret = ""
	local who = pipedloc:tag2str("#Pers")[1]
	if pipedloc["#Character"] == 0 then
		who = contexp
	end
	local tag = pipedloc[pipedloc["#Action"][1][1]][2]["name"]:sub(2)
	ret = Bd[Link[who][1]][tag]["Place"]["value"]
	return ret
end

function DateRetrieval(location)
	local pipedloc = pipe(location)
	local ret = {}
	local who = pipedloc:tag2str("#Pers")[1]
	if pipedloc["#Character"] ==0 then
		who = contexp
	end
	local tag = pipedloc[pipedloc["#Action"][1][1]][2]["name"]:sub(2)
	for i=1, #Bd[Link[who][1]][tag]["Date"], 1 do
		ret[#ret+1] = Bd[Link[who][1]][tag]["Date"][i]["value"].. " " .. Bd[Link[who][1]][tag]["Date"][i]["Period"]
	end
	return table.concat(ret, " or ")
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
			tag = pipopen[pipopen["#HasPast"][1][2]][3]["name"]
			value = pipopen:tag2str(tag)[1]
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
						if Bd[i][tag]["former"][j]["value"] == value and Bd[i]["Name"]["Firstname"]["value"] and Bd[i]["Name"]["Surname"]["value"] then
							ret[#ret+1] = Bd[i]["Name"]["Firstname"]["value"] .." "..Bd[i]["Name"]["Surname"]["value"]
						end
					end
				end
			elseif #timeTag == 0 and #pipopen["#Present"]==1 then
				for i=1, #Bd, 1 do	
					for j=1, #Bd[i][tag]["current"], 1 do
						if Bd[i][tag]["current"][j]["value"] == value and Bd[i]["Name"]["Firstname"]["value"] and Bd[i]["Name"]["Surname"]["value"] then
							ret[#ret+1] = Bd[i]["Name"]["Firstname"]["value"] .." "..Bd[i]["Name"]["Surname"]["value"]
						end
					end
				end
			else
				for k =1, #timeTag, 1 do
					for i=1, #Bd, 1 do 
						for j=1, #Bd[i][tag][timeTag[k]], 1 do 
							if Bd[i][tag][timeTag[k]][j]["value"] == value and Bd[i]["Name"]["Firstname"]["value"] and Bd[i]["Name"]["Surname"]["value"] then
								ret[#ret+1] = Bd[i]["Name"]["Firstname"]["value"] .." "..Bd[i]["Name"]["Surname"]["value"]
							end
						end
					end
				end
			end
		elseif #pipopen["#Descr"]>0then
			for i=1, #Bd, 1 do
				if #pipopen["#height"] > 0 then
					for j=1, #Bd[i]["Appearance"]["description"], 1 do
						if Bd[i]["Appearance"]["description"][j]["value"] == pipoen:tag2str("#height")[1] then
							ret[#ret +1] = Bd[i]["Name"]["Firstname"]["value"] .. " "..Bd[i]["Name"]["Surname"]["value"]
						end
					end
				else 
					local tofind = ""
					if #pipopen["#Hcolor"]>0 then
						tofind = pipopen:tag2str("#Hcolor")[1]
						tag = "Hair"
					else
						tag = pipopen[pipopen["#Descr"][1][2]][2]["name"]:sub(2)
						tofind = pipopen:tag2str("#Color")[1]
					end
					for j = 1, #Bd[i]["Appearance"]["Traits"][tag], 1 do
						if Bd[i]["Appearance"]["Traits"][tag][j]["value"] == tofind then
							ret[#ret+1] = Bd[i]["Name"]["Firstname"]["value"] .. " "..Bd[i]["Name"]["Surname"]["value"]
						end
					end
				end
			end
		else
			tag = pipopen[pipopen["#ActWho"][1][2]][2]["name"]
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
		ret [#ret +1 ] = "UNKNOWN"
	end
		return ret
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
	if #Link[chara] == 1 then
		for i =1, #Bd[Link[chara][1]]["Relation"],1 do
			if (Bd[Link[chara][1]]["Relation"][i]["lien"]:find(relation) and Bd[Link[chara][1]]["Relation"][i]["lien"]:find("/") == nil) 
			or (Bd[Link[chara][1]]["Relation"][i]["lien"]:find("/") and Bd[Link[chara][1]]["Relation"][i]["lien"]:find(relation)
				and Bd[Link[chara][1]]["Relation"][i]["lien"]:find(relation)< Bd[Link[chara][1]]["Relation"][i]["lien"]:find("/")) then
				ret[#ret+1] = Bd[Link[chara][1]]["Relation"][i]["Name"]
			end
		end
	elseif #Link[chara] > 1 then
		local nativ = {}
		print("Who are we refering to ?")
		for i=1, #Link[chara], 1 do
			local liases = {}
			for j=1, #Bd[i]["Aliases"], 1 do
				liases[#liases+1] = Bd[i]["Aliases"][j]["value"]
			end
			nativ[#nativ+1] = chara .. ": " table.concat(liases, ", ")
		end
		local pprnt = table.concat(nativ, " or \n")
		print (pprnt)
		print ("please choose an alias")
		local choice =io.read():gsub("%p", " %0 ")
		while pprnt:find(choice) == nil do
			print("i do not understand your choice, you may have done a mistake while writing it")
			print("please try again")
			choice = io.read():gsub("%p", " %0 ")
		end
		for i =1, #Bd[Link[choice][1]]["Relation"],1 do
			if (Bd[Link[choice][1]]["Relation"][i]["lien"]:find(relation) and Bd[Link[choice][1]]["Relation"][i]["lien"]:find("/") == nil) 
			or (Bd[Link[choice][1]]["Relation"][i]["lien"]:find("/") and Bd[Link[choice][1]]["Relation"][i]["lien"]:find(relation)
				and Bd[Link[choice][1]]["Relation"][i]["lien"]:find(relation)< Bd[Link[choice][1]]["Relation"][i]["lien"]:find("/")) then
				ret[#ret+1] = Bd[Link[choice][1]]["Relation"][i]["Name"]
			end
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

contextp = nil
bounce = false
contextq =	{}
contextq["piped"] = nil
contextq["str"] = nil
print([[Hello, i'm AskA.S.O.I.A.F., your chatbot dedicated to A Song Of Ice And Fire.]])
print([[What can i do for you today ? What do you need to know ?]])
while quitting ~= true do
local repprint = true
	local context = {}
	local interrogation =false
	local Charac = nil
	reply = ""
	if bounce == false then
		answer = io.read():gsub("%p", " %0 ")
	else
		bounce = false
	end
	piped = pipe(answer)
	quitting = #piped["#Quit"]>0
	if #piped["#ActWho"]>0 then
		local plies ={}		
		for i=1, #piped["#ActWho"],1 do
			local ctions ={}
			local rest = piped:tag2str("#ActWho")[i]
			ctions[1] = pipe(rest):tag2str("#Action")[1]
			local topast = rest:sub(rest:find(ction[1])-1)
			for j=1, #pipe(rest)["#ActEnum"], 1 do
				ctions[#ctions+1] = pipe(rest):tag2str("#ActEnum")[j]
			end
			for j=1, #ctions, 1 do
				local acrion = topast .. ctions[j]
				local ply = openWho(acrion)
				if #ply == 0 then
					plies[#plies+1] = "I'm sorry, i can find No one who match what you want"
				elseif ply[1] ~= "UNKNOWN" then
					local lv = pipe(acrion):tag2str("#VRB")[#pipe(acrion)["#VRB"]]
					plies[#plies+1] = acrion:sub(acrion:find(lv)+lv:len()+1)..": ".. table.concat(ply, ", ")
				end
			end
		end
		reply = table.concat(plies, "\n")
	elseif #piped["#Character"] == 0 then
		if #piped["#Pers"] == 0 then
			if(quitting == false) then
				repprint = false
				print ("Who are you talking about ?")
			end
		else
			Charac = contextp
		end
	else
		Charac = piped:tag2str("#Character")[1]
		contextp = Charac
	end
	if #piped["#TiQuestion"]>0 then
		for j=1, #piped["#TiQuestion"], 1 do
			local locat = piped:tag2str("#TiQuestion")[j]
			local piploc = pipe(locat)
			local start = locat:sub(1, locat:find(piploc:tag2str("#Pers")[1])-1)
			local ending = locat:sub(locat:find(piploc:tag2str("#Pers")[#piploc["#Pers"]]) + piploc:tag2str("#Pers")[#piploc["#Pers"]]:len())
			for i=1, #piploc["#Pers"], 1 do
				local treat =""
				local sor = piploc:tag2str("#Pers")[i]
				if #Link[sor] > 1 then
					local nativ = {}
					print("Who are we refering to ?")
					for i=1, #Link[sor], 1 do
						local liases = {}
						for k=1, #Bd[i]["Aliases"], 1 do
							liases[#liases+1] = Bd[i]["Aliases"][k]["value"]
						end
						nativ[#nativ+1] = sor .. ": " table.concat(liases, ", ")
					end
					local pprnt = table.concat(nativ, " or \n")
					print (pprnt)
					print ("please choose an alias")
					local choice =io.read():gsub("%p", " %0 ")
					while pprnt:find(choice) == nil do
						print("i do not understand your choice, you may have done a mistake while writing it")
						print("please try again")
						choice = io.read():gsub("%p", " %0 ")
					end
					treat = choice
				else
					treat = sor
				end
				local location = start .. sor .. ending
				local but = {}
				but[1] = piploc:tag2str("#Action")[1]
				if #piploc["#EnumAc"]>0 then
					for m=1, #piploc["#EnumAc"],1 do
						but[#but+1]= piploc:tag2str("#EnumAc")[m]
					end
				end
				contextq["piped"] = pipe(location)
				contextq["str"] = location
				local begin = location:sub(1, location:find(but[1])-1)
				local final = location:sub(location:find(but[#but])+location:len())
				for n=1, #but, 1 do
					local ply = DateRetrieval(begin..but[n]..final)
					if ply == nil then 
						print( "I'm sorry, i do not have this information in my database.")
					else
						print(ply)
					end
				end
			end
		end
	end
	if #piped["#LoQuestion"]>0 then
		for j=1, #piped["#LoQuestion"], 1 do
			local locat = piped:tag2str("#LoQuestion")[j]
			local piploc = pipe(locat)
			local start = locat:sub(1, locat:find(piploc:tag2str("#Pers")[1])-1)
			local ending = locat:sub(locat:find(piploc:tag2str("#Pers")[#piploc["#Pers"]]) + piploc:tag2str("#Pers")[#piploc["#Pers"]]:len())
			for i=1, #piploc["#Pers"], 1 do
				local treat =""
				local sor = piploc:tag2str("#Pers")[i]
				if #Link[sor] > 1 then
					local nativ = {}
					print("Who are we refering to ?")
					for i=1, #Link[sor], 1 do
						local liases = {}
						for k=1, #Bd[i]["Aliases"], 1 do
							liases[#liases+1] = Bd[i]["Aliases"][k]["value"]
						end
						nativ[#nativ+1] = sor .. ": " table.concat(liases, ", ")
					end
					local pprnt = table.concat(nativ, " or \n")
					print (pprnt)
					print ("please choose an alias")
					local choice =io.read():gsub("%p", " %0 ")
					while pprnt:find(choice) == nil do
						print("i do not understand your choice, you may have done a mistake while writing it")
						print("please try again")
						choice =io.read():gsub("%p", " %0 ")
					end
					treat = choice
				else
					treat = sor
				end
				local location = start .. sor .. ending
				local but = {}
				but[1] = piploc:tag2str("#Action")[1]
				if #piploc["#EnumAc"]>0 then
					for m=1, #piploc["#EnumAc"],1 do
						but[#but+1]= piploc:tag2str("#EnumAc")[m]
					end
				end
				contextq["piped"] = pipe(location)
				contextq["str"] = location
				local begin = location:sub(1, location:find(but[1])-1)
				local final = location:sub(location:find(but[#but])+location:len())
				for n=1, #but, 1 do
					local ply = LocationRetrieval(begin..but[n]..final)
					if ply == nil then 
						print( "I'm sorry, i do not have this information in my database.")
					else
						print(ply)
					end
				end
			end
		end
	elseif #piped["#WhatPrecPossess"]>0 then
		for i=1, #piped["#WhatPrecPossess"], 1 do
			local prec = piped:tag2str("#WhatPrecPossess")[i]
			local piprec = pipe(prec)
			local tags = {}
			tags[1] = piprec[piprec["#Wanted"][1][1]][2]["name"]
			if(tags[1]:sub(tags[1]:len()) == "s") then
				tags[1] = tags[1]:sub(1, tags[1]:len()-1)
			else
				tags[1] = tags[1] .. "s"
			end
			if #piprec["#EnumWat"]>0 then
				for d=1, #prec["#EnumWat"], 1 do
					local tt = piprec[piprec["#EnumWat"][d][1]][name]
					if tt:sub(tt:len()) == "s" then
						tags[#tags+1] = tt:sub(1,tt:len()-1)
					else
						tags[#tags+1]= tt .. "s" 
					end
				end
			end
			for p=1, #piprec["#Possess"], 1 do
				local pos = piprec:tag2str("#Possess")[p]
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
											character[#character+1] = cra[n]
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
					contextq["piped"] = pipe(atrib)
					contextq["str"] = atrib
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
						local stion = start .. buts[k] .. ending
						local trep = PossRetrieval(stion,#piped["#Past"]>0)
						
						if #trep ==0 then
							print( "I don't know about this information, sorry")
						else
							local pri ={}
							if prec:find(" or ") then
								local tofind = tags[math.random(#tags)]
								for n=1, #trep, 1 do
									if #pipe(trep[n])[tofind]>0 then
										pri[#pri+1] = trep[n]
									end
								end
							else
								for n=1, #trep, 1 do
									for m=1, #tags, 1 do
										if #pipe(trep[n])[tags[m]]>0 then
											pri[#pri+1] = trep[n]
										end
									end
								end
							end
							
							if #piped["#Plural"]>0 or buts[k]:sub(buts[k]:len()) == "s" then
								print(prec:sub(prec:find(piprec:tag2str("#Det")[1]), prec:find("of") +2).. " ".. stion .. " " .. piprec:tag2str("#VRB")[1] .. " " ..table.concat(pri, ", "))
							else
								print(prec:sub(prec:find(piprec:tag2str("#Det")[1]), prec:find("of") +2).. " ".. stion .. " " .. piprec:tag2str("#VRB")[1] .. " " .. pri[math.random(#pri)])
							end
						end
					end
				end
			end
		end
	elseif #piped["#Possess"]>0 then
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
										character[#character+1] = cra[n]
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
				
				contextq["piped"] = pipe(atrib)
				contextq["str"] = atrib
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
					local stion = start .. buts[k] .. ending
					local trep = PossRetrieval(stion,#piped["#Past"]>0)
					
					if #trep ==0 then
						print( "I don't know about this information, sorry")
					else
						if #piped["#Plural"]>0  or buts[k]:sub(buts[k]:len()) == "s" and buts[k]~="alias" then
							print(stion .. " : " ..table.concat(trep, ", "))
						else
							print(stion .. " : " .. trep[math.random(#trep)])
							local op = io.read():gsub("%p", " %0 ")
							while op == "and" or op == "And" or op == "and ?" or op == "And ?" do
								print (trep[math.random(#trep)])
								op = io.read():gsub("%p", " %0 ")
							end
						end
					end
				end
			end
		end
	elseif #piped["#Person"] > 0  then 
		for s=1, #piped["#Person"], 1 do
			local person = piped:tag2str("#Person")[s]
			local personpi = pipe(person)
			local found ={}
			local fill = true
			if #personpi["#Wed"] > 0 then
				for i=1, #personpi["#Wed"], 1 do
					local sors = {}
					local wed = personpi:tag2str("#Wed")[i]
					local wedpipe = pippe(wed)
					sors[1] = pipe(wed):tag2str("#Who")[#pipe(wed)["#Who"]]
					local cat = wed:sub(1, wed:find(sors[1])-1)
					
					if #wedpipe["#EnumWed"] >0 then
						for j=1, #wedpipe["#EnumWed"], 1 do
							sors[#sors + 1] = wedpipe:tag2str("#EnumWed")[j]
						end
					end
					
					for j=1, #sors, 1 do
						local treat = ""
						if #Link[sors[j]] > 1 then
							local nativ = {}
							print("Who are we refering to ?")
							for i=1, #Link[sors[j]], 1 do
								local liases = {}
								for k=1, #Bd[i]["Aliases"], 1 do
									liases[#liases+1] = Bd[i]["Aliases"][k]["value"]
								end
								nativ[#nativ+1] = sors[j] .. ": " table.concat(liases, ", ")
							end
							local pprnt = table.concat(nativ, " or \n")
							print (pprnt)
							print ("please choose an alias")
							local choice =io.read():gsub("%p", " %0 ")
							while pprnt:find(choice) == nil do
								print("i do not understand your choice, you may have done a mistake while writing it")
								print("please try again")
								choice = io.read():gsub("%p", " %0 ")
							end
							treat = choice
						elseif #Link[sors[j]] == 1 then
							treat = sors[j]
						end
						local nfound ={}
						for k=1, #Bd[Link[treat][1]]["Relation"], 1 do	
							if Bd[Link[treat][1]]["Relation"][k]["lien"]:find("husband")
							or Bd[Link[treat][1]]["Relation"][k]["lien"]:find("wife")
							or Bd[Link[treat][1]]["Relation"][k]["lien"]:find("spouse") then
								if fill == true then
									found[#found+1] = Bd[Link[treat][1]]["Relation"][k]["Name"]
									fill = false
								else
									if table.concat(found,", "):find(Bd[Link[treat][1]]["Relation"][k]["Name"]) then
										nfound[#nfound+1] = Bd[Link[treat][1]]["Relation"][k]["Name"]
									end
								end
								print (treat .. " is marrried to ".. Bd[Link[treat][1]]["Relation"][k]["Name"])
							end
						end
						if fill == false then found = nfound end
					end
				end
			elseif #personpi["#RelPossess"] == 1 then
					local relpiposess = pipe(personpi:tag2str("#RelPossess")[1])
					if #relpiposess["#PossEnum"] > 0 then
						local sors = {}
						sors[1] = relpiposess:tag2str("#Possessor")[1]
						for i=1, #relpiposess["#PossEnum"], 1 do
							sors[#sors+1] = relpiposess:tag2str("#PossInEnum")[i]
						end
						local rel = personpi:tag2str("#RelPossess")[1]
						local start = rel:sub(1, rel:find(sors[1])-1)
						local ending = rel:sub(rel:find(sors[#sors])+sors[#sors]:len())
						for i=1, #sors, 1 do
							local actpossess = start .. sors[i] .. ending
							print(actpossess)
							contextq["piped"] = pipe(actpossess)
							contextq["str"] = actpossess
							if #pipe(actpossess)["#Relation"] > 1 then
								print( table.concat(PossesMultiRel(actpossess,piped), ".\n"))
							else
								print( actpossess ..": ".. table.concat(RelpossesSimpleRetrieve(actpossess), ", "))
							end
						end
					else
						contextq["piped"] = pipe(personpi:tag2str("#RelPossess")[1])
						contextq["str"] = personpi:tag2str("#RelPossess")[1]
						if #relpiposess["#Relation"] > 1 then
							local cars = PossesMultiRel(personpi:tag2str("#RelPossess")[1],piped)
							if fill == true then
								found = cars
								fill = false
							else
								local nfound = {}
								for c=1, #cars, 1 do
									if table.concat(found, ", "):find(cars[c]) then
										nfound[#nfound+1] = cars[c]
									end
								end
								found = nfound
							end
							print( table.concat(cars, ".\n"))
						else
							local cars=RelpossesSimpleRetrieve(relpiposess)
							if fill == true then
								found =cars
								fill = false
							else
								local nfound = {}
								for c=1, #cars, 1 do
									if table.concat(found, ", "):find(cars[c]) then
										nfound[#nfound+1] = cars[c]
									end
								end
								found = nfound
							end
							print( personpi:tag2str("#RelPossess")[1] ..": ".. table.concat(cars, ", "))
						end
					end
			 elseif #personpi["#RelPossess"] > 1 then 
				local repList = {}
				for i= #personpi["#RelPossess"], 1, -1 do 
					local gloposs = personpi:tag2str("#RelPossess")[i]
					local sors ={}
					sors[1] = personpi:tag2str("#Possessor")[i]
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
										contextq["piped"] = pipe(treat)
										contextq["str"] = treat
									end
								end
							end
							i = i-#piposor["#RelPossess"] +1
						else
							if #pipe(poss)["#Relation"] >1 then
								local cars = RelPossessRetrieve(poss, piped)
								if fill == true then
									found =cars
									fill = false
								else
									local nfound = {}
									for c=1, #cars, 1 do
										if table.concat(found, ", "):find(cars[c]) then
											nfound[#nfound+1] = cars[c]
										end
									end
									found = nfound
								end
								print (table.concat(cars, ".\n"))
							else
								local cars = RelpossesSimpleRetrieve(poss)
								if fill == true then
									found =cars
									fill = false
								else
									local nfound = {}
									for c=1, #cars, 1 do
										if table.concat(found, ", "):find(cars[c]) then
											nfound[#nfound+1] = cars[c]
										end
									end
									found = nfound
								end
								print (poss .. ": ".. table.concat(cars, ", ").. ".")
							end
							contextq["piped"] = pipe(poss)
							contextq["str"] = poss
						end
						
					end
				end
				
			end
			if answer:find("also") then
				print ("you probably talked about ".. table.concat(found , ", "))				
			end
		end
	else
		if #piped["#Aliases"]>0 then
		contextq["piped"] = piped
		continue = false
		contextq["str"] = answer
		local cra = piped:tag2str("#Pers")
			for j=1, #cra, 1 do
				local treat =""
				local sor = cra[j]
				if #Link[sor] > 1 then
					local nativ = {}
					print("Who are we refering to ?")
					for i=1, #Link[sor], 1 do
						local liases = {}
						for k=1, #Bd[i]["Aliases"], 1 do
							liases[#liases+1] = Bd[i]["Aliases"][k]["value"]
						end
						nativ[#nativ+1] = sor .. ": " table.concat(liases, ", ")
					end
					local pprnt = table.concat(nativ, " or \n")
					print (pprnt)
					print ("please choose an alias")
					local choice =io.read():gsub("%p", " %0 ")
					while pprnt:find(choice) == nil do
						print("i do not understand your choice, you may have done a mistake while writing it")
						print("please try again")
						choice = io.read():gsub("%p", " %0 ")
					end
					treat = choice
				else
					treat = sor
				end
				
				for i=1, #Bd[Link[treat][1]]["Aliases"], 1 do
					print (Bd[Link[treat][1]]["Aliases"][i]["value"])
				end
			end
		end
		if continue == true then
			if #piped["#member"]>0 or #piped["#Titles"]>0 or #piped["#House"]>0 or #piped["#Allegiance"]>0 then
				contextq["piped"] = piped
				contextq["str"] = answer
				local cra = piped:tag2str("#Pers")
				local ret ={}
				for j=1, #cra, 1 do
					local treat =""
					local sor = cra[j]
					if #Link[sor] > 1 then
						local nativ = {}
						print("Who are we refering to ?")
						for i=1, #Link[sor], 1 do
							local liases = {}
							for k=1, #Bd[i]["Aliases"], 1 do
								liases[#liases+1] = Bd[i]["Aliases"][k]["value"]
							end
							nativ[#nativ+1] = sor .. ": " table.concat(liases, ", ")
						end
						local pprnt = table.concat(nativ, " or \n")
						print (pprnt)
						print ("please choose an alias")
						local choice =io.read():gsub("%p", " %0 ")
						while pprnt:find(choice) == nil do
							print("i do not understand your choice, you may have done a mistake while writing it")
							print("please try again")
							choice = io.read():gsub("%p", " %0 ")
						end
						treat = choice
					else
						treat = sor
					end
					
					local Chara = Bd[Link[treat][1]]
					local timeTag = {}
					if #piped["#Timestamp"]>0 then
						for k =1, #piped:tag2str("#Timestamp"), 1 do
							local sform = piped:tag2str("#Timestamp")[k]
							timeTag[#timeTag+1] = AnyToTimestamp(sform)
						end
					end	
					if (#piped:tag2str("#Timestamp")==1 and (piped:tag2str("#Timestamp")[1]:lower() == "former"))or (#piped["#Past"]>0 == true and #piped:tag2str("#Timestamp")==0)then
						if #piped["#Allegiance"]>0 then
							for i = 1, #Chara["Allegiance"]["former"], 1 do
								ret[#ret+1] = Chara["Allegiance"]["former"][i]["value"]
							end
						end
						if #piped["#Titles"]>0 then
							for i = 1, #Chara["Titles"]["former"], 1 do
								ret[#ret+1] = Chara["Titles"]["former"][i]["value"]
							end
						end
						if #piped["#House"]>0 then
							for i = 1, #Chara["House"]["former"], 1 do
								ret[#ret+1] = Chara["House"]["former"][i]["value"]
							end
						end
					elseif (#piped:tag2str("#Timestamp")==1 and( piped:tag2str("#Timestamp")[1]:lower() == "current" )) or (#piped["#Past"] == 0 and #piped:tag2str("#Timestamp")==0)then
						if #piped["#Allegiance"]>0 then
							for i = 1, #Chara["Allegiance"]["current"], 1 do
								ret[#ret+1] = Chara["Allegiance"]["current"][i]["value"]
							end
						end
						if #piped["#Titles"]>0 then
							for i = 1, #Chara["Titles"]["current"], 1 do
								ret[#ret+1] = Chara["Titles"]["current"][i]["value"]
							end
						end
						if #piped["#House"]>0 then
							for i = 1, #Chara["House"]["current"], 1 do
								ret[#ret+1] = Chara["House"]["current"][i]["value"]
							end
						end
					elseif #piposs:tag2str("#Timestamp")==1 then
						if #piped["#Allegiance"]>0 then
							for i = 1, #Chara["Allegiance"]["claim"], 1 do
								ret[#ret+1] = Chara["Allegiance"]["claim"][i]["value"]
							end
						end
						if #piped["#Titles"]>0 then
							for i = 1, #Chara["Titles"]["claim"], 1 do
								ret[#ret+1] = Chara["Titles"]["claim"][i]["value"]
							end
						end
						if #piped["#House"]>0 then
							for i = 1, #Chara["House"]["claim"], 1 do
								ret[#ret+1] = Chara["House"]["claim"][i]["value"]
							end
						end
					elseif #piposs:tag2str("#Timestamp")>1 then 
						if possess:find(" or ") then
							local chosen = timeTag[math.random(#timeTag)]
							if #piped["#Allegiance"]>0 then
								for i=1, #Chara["Allegiance"][chosen], 1 do
									ret[#ret +1] = Chara["Allegiance"][chosen][i]["value"]
								end
							end
							if #piped["#Titles"]>0 then
								for i=1, #Chara["Titles"][chosen], 1 do
									ret[#ret +1] = Chara["Titles"][chosen][i]["value"]
								end
							end
							if #piped["#House"]>0 then
								for i=1, #Chara["House"][chosen], 1 do
									ret[#ret +1] = Chara["House"][chosen][i]["value"]
								end
							end
						else
							for k=1, #timeTag, 1 do	
								if #piped["#Allegiance"]>0 then
									for i = 1, #Chara["Allegiance"][timeTag[k]], 1 do
										ret[#ret+1] = Chara["Allegiance"][timeTag[k]][i]["value"]
									end
								end
								if #piped["#Titles"]>0 then
									for i = 1, #Chara["Titles"][timeTag[k]], 1 do
										ret[#ret+1] = Chara["Titles"][timeTag[k]][i]["value"]
									end
								end
								if #piped["#House"]>0 then
									for i = 1, #Chara["House"][timeTag[k]], 1 do
										ret[#ret+1] = Chara["House"][timeTag[k]][i]["value"]
									end
								end
							end
						end
					end
				end
				print (table.concat(ret, ", "))
			else
				if contextq["piped"] and contextq["str"] and #piped["#Quit"] == 0 and #piped["#Pers"]>0 then
					local pipeq = contextq["piped"]
					local pers = piped:tag2str("#Character")[1]
					answer = contextq["str"]:sub(1,contextq["str"]:find(pipeq:tag2str("#Pers")[1])-1 )..pers..contextq["str"]:sub(contextq["str"]:find(pipeq:tag2str("#Pers")[1])+pipeq:tag2str("#Pers")[1]:len())
					bounce = true
				end
			end
		end
	end
	if bounce == false and repprint == true then
		if quitting == false then		print(retorq[math.random(#retorq)])	end
		if reply ~= "" then
			print (reply..".")
		end
	end
end

print([[I'm glad that we could have a talk.
See you later.
And remember, Winter is Coming.]])
	
