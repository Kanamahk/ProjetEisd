local L_FIRSTNAME="../Lexique_CharactersFirstname.txt"
local L_SURNAME="../Lexique_CharactersSurname.txt"
local L_BOOKS="../Lexique_Books.txt"
local L_ALIAS="../Lexique_Alias.txt"
local L_TITLES="../Lexique_Titles.txt"
local L_CASTLES = "../Castles.txt"
local L_CITIES = "../Cities.txt"
local L_ISLANDS = "../Islands.txt"
local L_REGIONS = "../Regions.txt"

firstnames={}
surnames={}
books={}
alias={}
titles={}
castles={}
cities={}
islands={}
regions={}

--------------------------- FILES WITH NO ,
local file=io.open(L_FIRSTNAME,"r")
for line in file:lines() do
	table.insert(firstnames,line)
end
file=io.open(L_SURNAME,"r")
for line in file:lines() do
	table.insert(surnames,line)
end
file=io.open(L_TITLES,"r")
for line in file:lines() do
	table.insert(titles,line)
end
file=io.open(L_ALIAS,"r")
for line in file:lines() do
	table.insert(alias,line)
end
file=io.open(L_BOOKS,"r")
for line in file:lines() do
	table.insert(books,line)
end

--------------------------- FILES WITH ,
for line in io.lines(L_CASTLES) do
    for sen in line:gmatch("[^,]+") do
        castles[#castles+1] = sen:gsub("^%s", ""):gsub("%s*$", "")
    end
end
for line in io.lines(L_CITIES) do
    for sen in line:gmatch("[^,]+") do
        cities[#cities+1] = sen:gsub("^%s", ""):gsub("%s*$", "")
	end
end
for line in io.lines(L_REGIONS) do
    for sen in line:gmatch("[^,]+") do
		sen =sen:gsub("^%s", ""):gsub("%s*$", "")
        regions[#regions+1] = sen
        regions[#regions+1] = sen:lower()
    end
end
for line in io.lines(L_ISLANDS) do
    for sen in line:gmatch("[^,]+") do
		sen =sen:gsub("^%s", ""):gsub("%s*$", "")
        islands[#islands+1] = sen
        islands[#islands+1] = sen:lower()
    end
end

	
pipe = dark.pipeline()
pipe:basic()

-------------------------------------------------------------
---------------------------- PATTERNS -----------------------
-------------------------------------------------------------

--------------------------- BASE
pipe:lexicon("#firstname", firstnames)
pipe:lexicon("#surname", surnames)
pipe:lexicon("#alias", alias)
pipe:lexicon("#title", titles)

pipe:lexicon("#castle", castles)
pipe:lexicon("#city", cities)
pipe:lexicon("#isle", islands)
pipe:lexicon("#region", regions)

------------------------------ PLACES
pipe:pattern([[
	[#place
			#castle
			| #city
			| #isle
			| #region 
	]
]])

---------------------------- CHARACTERS
pipe:pattern([[
	[#character(
			(#firstname #surname) | (#firstname #alias) 
			| (#alias #surname | #alias #alias) 
			| (#title #firstname #surname) | (#title #surname) | (#title #firstname ) | ( #title 'of' ((#w)|(#W)).*? #place) 	
			| #firstname | #alias
	)]
]])

pipe:pattern([[
	[#filiation(
		'son'
		| 'daughter'
		| 'mother'
		| 'father'
	)]
]])

pipe:pattern([[
	[#family(
		( #filiation 'of' (#w).*? #character)
		| ( #filiation (',')? #character)
	)]
]])
----------------------------- BIRTH
pipe:pattern([[
	[#date (
			#d 'AC'
			#d 'BC' 
	)]
]])

pipe:pattern([[
	[#age (
			#w 'years' 'old'
	)]
]])

pipe:pattern("[#birthdate 'born' (#w).*? 'in' #date]")

pipe:pattern([[
	[#birthplace(
		('born' (#w)? 'at' #place )
		| ( ('born' 'at' (#w).*?) #place) 
	)]
]])

pipe:pattern([[
	[#birth
		( ('born' (#w).*? #place (#w).*? #date )
		| ('born' (#w).*? #date (#w).*? #place )
		| #birthdate
		| #birthplace )
	]
]])

local tags = {
	["#firstname"]	= "blue",
	["#surname"]	= "blue",
	["#title"]	= "blue",
	["#alias"]	= "blue",
	["#character"] 	= "blue",
	
	["#castle"]	= "red",
	["#city"]	= "red",
	["#isle"]	= "red",
	["#region"]	= "red",
	["#place"]	= "red",
	
	["#date"]		= "yellow",
	["#num"]		= "yellow",	
	["#age"]		= "yellow",	
	["#birthdate"]	= "yellow", 
	["#birthplace"]	= "yellow", 
	["#birth"]		= "yellow", 
	
	["#filiation"] = "cyan",
	["#family"] = "cyan",
}

-------------------------------------------------------------
----------------- PRE-TREATMENT FUNCTIONS -------------------
-------------------------------------------------------------
function process(sen)
    sen = sen:gsub("%p", " %0 ") --a retenir %0 etc
	-- print("PROCESS SEN", sen)
	return sen
end

function splitsen(line)
	sentences={}
	for sen in line:gmatch("(.-[.?!])") do 
		-- print("SPLIT SEN ", sen)
		table.insert(sentences,process(sen))
	end 
	return sentences
end
	

-------------------------------------------------------------
------------------ TAG-RELATED FUNCTIONS --------------------
-------------------------------------------------------------
function havetag(seq, tag)
	return #seq[tag] ~= 0
end

function tagstr(seq, tag, lim_debut, lim_fin)
	lim_debut = lim_debut or 1
	lim_fin   = lim_fin   or #seq
	if not havetag(seq, tag) then
		return nil,nil,nil
	end
	local list = seq[tag]
	-- print("\t\t\tLIST : ", serialize(list))
	for i, position in ipairs(list) do
		local debut, fin = position[1], position[2]
		-- print("DEB : ", debut, " FIN : ", fin)
		if debut >= lim_debut and fin <= lim_fin then
			local tokens = {}
			for i = debut, fin do
				tokens[#tokens + 1] = seq[i].token
			end
			-- print(" TOKENS: ", table.concat(tokens," "))
			return table.concat(tokens, " "),debut,fin
		end
	end
	return nil
end

function GetValueInLink(seq, entity, link)
	list={}
	for i, pos in ipairs(seq[link]) do
		-- print("\t\ti: ",i," pos 1: ",pos[1], "pos 2 : ",pos[2])
		res,deb,fin = tagstr(seq, entity, pos[1], pos[2])
		-- print("res, deb, fin : ", res, deb, fin)
		if res then
			list[res]={}
			list[res].d=deb
			list[res].f=fin
		end
	end
	return list
end

-------------------------------------------------------------
------------------ DB-RELATED FUNCTIONS --------------------
-------------------------------------------------------------
function isCharInIndex(name,dbIndex)
	-- print("name: ",name)
	for i, pos in pairs(dbIndex) do
		-- print("i : ",i, "et pos: ",pos)
		-- print("db index de i ",serialize(dbIndex[i]))
		if (i == name) then	
			return true, pos
		end
	end
	return false, nil
end

-- function possibleChar(index,db)
	-- res={}
	-- for i, pos in pairs(index) do
		-- print("i: ",i, "pos : ",pos)
		-- table.insert(res,db[i])
	-- end
	-- if (#res==1) then	
		-- print("res: ", serialize(res))
		-- return res
	-- else	
		-- print("Multiple possibilities")
		-- return nil
	-- end
	-- print("taille res : ",#res)
	-- print("res: ", serialize(res))
-- end

function isIndexAlreadyThere(index,tab)
	for i, pos in pairs(tab) do
		-- print("index : ",index," i : ",i, "pos : ",pos)
		if pos == index then
			return true
		end
	end
	return false
end
-------------------------------------------------------------
---------------- CHAR DATABSE - FIRST STEP ------------------
-------------------------------------------------------------
-- local db = dofile("../DB_Characters.lua") --On récupère la BD faite avec les données structurées 
local db = dofile("../exempleCharacterBD.lua") --db factice car pas enocre faite



-------------------------------------------------------------
--------------------- INDEX DATABASE ------------------------
-------------------------------------------------------------

charIndex=dofile("../DB_Index.lua") -- On récupère la BD si elle existe déjà

for i, pos in pairs(db) do
	local fn = pos.Name.Firstname.value
	local sn = pos.Name.Surname.value
	local name = fn.." "..sn
	
	charIndex[0]=i
	
	--Insertion index du Nom Complet
	if charIndex[name]==nil then
		charIndex[name] = {}
	end
	if (isIndexAlreadyThere(i,charIndex[name])==false) then
		table.insert(charIndex[name],i)
	end
	
	--Insertion index Nom Famille
	if charIndex[sn]==nil then
		charIndex[sn] = {}
	end
	if (isIndexAlreadyThere(i,charIndex[sn])==false) then
		table.insert(charIndex[sn],i)
	end

	--Insertion index Prenom
	if charIndex[fn]==nil then
		charIndex[fn] = {}
	end
	if (isIndexAlreadyThere(i,charIndex[fn])==false) then
		table.insert(charIndex[fn],i)
	end
	
	--Insertion index Prenom
	if charIndex[fn]==nil then
		charIndex[fn] = {}
	end
	if (isIndexAlreadyThere(i,charIndex[fn])==false) then
		table.insert(charIndex[fn],i)
	end
	
	-- print("pos ", serialize(pos))
	-- print("pos.aliases", serialize(pos.Aliases))
	if pos.Aliases~=nil then
		for j,p in pairs(pos.Aliases) do
			local al=p.value
			if charIndex[al]==nil then
				charIndex[al] = {}
			end
			if (isIndexAlreadyThere(i,charIndex[al])==false) then
				table.insert(charIndex[al],i)
			end
		end
	end
	
	--maj index
	charIndex[0]=charIndex[0]+1
end


-- print(" char ind ", serialize(charIndex))
--On met le tout dans un fichier
local out_file = io.open("../DB_Index.lua", "w")
out_file:write("return ")
out_file:write(serialize(charIndex))
out_file:close()


-------------------------------------------------------------
--------------- CHAR DATABSE - SECOND STEP ------------------
-------------------------------------------------------------
line={}
-- TEST SUR UN FICHIER 
local test_file = io.open("../FilesForDb/Bran Stark.txt")
for l in test_file:lines() do 
	-- print("LINE",l)
	sent=splitsen(l)
	-- print("SENT: ", sent)
	for i, pos in pairs(sent) do
		-- print("\tpos : ", pos)
		if( pos~=nil and pos~={} and pos~="%p") then
			table.insert(line,dark.sequence(pos))
		end
	end
end


path,filename,extension=string.match(test_file, "(.-)([^\\/]-%.?([^%.\\/]*))$") --on recupere le nom du fichier
filename=filename:gsub("[.]", " . ") --On met un espace de part et d'autre 

-- A récupérer dans le nom du fichier !!!
CHARACTER=GetValueInLink(pipe(filename),"#character","#character") or nil
ALIAS=GetValueInLink(pipe(filename),"#alias","#character") or nil
SURNAME=GetValueInLink(pipe(filename),"#surname","#character") or nil

for i, val in pairs(line) do
	seq=pipe(val)
	
	isTag, d, f = havetag(seq, "#character")
	if isTag then
		local character = GetValueInLink(seq, "#character", "#character")
		local title = GetValueInLink(seq, "#title", "#character") or ""
		local firstname = GetValueInLink(seq, "#firstname", "#character") or ""
		local alias = GetValueInLink(seq, "#alias", "#character") or ""
		local surname  = GetValueInLink(seq, "#surname",   "#character") or ""
		
		
		-- print("char: ",character, "\n\tfn: ",firstname," \n\tsn : ",surname, "\n\talias: ", alias)
		
		if(isCharInIndex(character,charIndex) == true) then
			b,listIndex=isCharInIndex(character,charIndex)
		end

		if(isCharInIndex(alias.." "..surname,charIndex) == true) then
			b,listIndex=isCharInIndex(alias.." "..surname,charIndex)
		end


		-- if (#listIndex==1) then
			-- al={ value = alias,
				-- trust = "NS-E",}
			-- print("ind: ",listIndex[1])
			-- print("db[ind] : ",serialize(db[2]))
			-- if db[listIndex[1]].Aliases == nil then
				-- db[listIndex[1]].Aliases={}
			-- end
			-- print("aliases : ",serialize(db[2]))
		
			-- table.insert(db[listIndex[1]].Aliases,al)
		-- end
		
	end
	
end

local out_file = io.open("../DB_Characters.lua", "w")
out_file:write("return ")
out_file:write(serialize(db))
out_file:close()	