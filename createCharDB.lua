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

	
local pipe = dark.pipeline()
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
	)]
]])
----------------------------- BIRTH
pipe:pattern([[
	[#date (
			#d 'AC'
			#d 'BC' 
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
	["#character"] 	= "red",
	
	["#castle"]	= "blue",
	["#city"]	= "blue",
	["#isle"]	= "blue",
	["#region"]	= "blue",
	["#place"]	= "red",
	
	["#date"]		= "blue",
	["#birthdate"]		= "blue", 
	["#birthplace"]		= "blue", 
	["#birth"]		= "yellow", 
	
	["#filiation"] = "red",
	["#family"] = "yellow",
}

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
		return nil
	end
	local list = seq[tag]
	for i, position in ipairs(list) do
		local debut, fin = position[1], position[2]
		if debut >= lim_debut and fin <= lim_fin then
			local tokens = {}
			for i = debut, fin do
				tokens[#tokens + 1] = seq[i].token
			end
			return table.concat(tokens, " ")
		end
	end
	return nil
end

function GetValueInLink(seq, entity, link)
	for i, pos in ipairs(seq[link]) do
		local res = tagstr(seq, entity, pos[1], pos[2])
		if res then
			return res
		end
	end
	return nil
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
		print("index : ",index," i : ",i, "pos : ",pos)
		if pos == index then
			return true
		end
	end
	return false
end
-------------------------------------------------------------
------------------ DATABSE - FIRST STEP ---------------------
-------------------------------------------------------------
-- Exemple de bd
-- local db = dofile("../Database_Characters.lua")
local db = dofile("../exempleCharacterBD.lua")

--On parcourt les fichiers contenus dans le dossier 
-- dirname='../FilesForDb'
-- f=io.popen(dirname.." dir") --/!\ Permission denied !!
-- for name in f:lines() do print(name) end


charIndex=dofile("../Database_CharIndex.lua") -- On récupère la BD si elle existe déjà

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
local out_file = io.open("../Database_CharIndex.lua", "w")
out_file:write("return ")
out_file:write(serialize(charIndex))
out_file:close()

-------------------------------------------------------------
------------------ DATABSE - SECOND STEP --------------------
-------------------------------------------------------------
line={}
-- TEST
local test_file = io.open("../FilesForDb/Bran Stark.txt")
for l in test_file:lines() do 
	-- print("LINE",l) 
	for sen in l do
		print("sen : ", sen)
	table.insert(line,l)
end
print(" table line: ", serialize(line))

local seq = "test"
pipe(seq)
print(seq:tostring(tags))

if havetag(seq, "#character") then
	local character = GetValueInLink(seq, "#character", "#character")
	local title = GetValueInLink(seq, "#title", "#character")
	local firstname = GetValueInLink(seq, "#firstname", "#character") or nil
	local alias = GetValueInLink(seq, "#alias", "#character") or nil 
	local surname  = GetValueInLink(seq, "#surname",   "#character") or nil
	
	
	print("\nchar: ",character, "\n\tfn: ",firstname," \n\tsn : ",surname, "\n\talias: ", alias)
	
	if(isCharInIndex(character,charIndex) == true) then
		print("char true")
		b,listIndex=isCharInIndex(character,charIndex)
	end
	if(isCharInIndex(alias.." "..surname,charIndex) == true) then
		print("al+surn true")
		b,listIndex=isCharInIndex(alias.." "..surname,charIndex)
		-- print("listIndex ",serialize(listIndex))
	end

	if (#listIndex==1) then
		al={ value = alias,
			trust = "NS-E",}
		print("ind: ",listIndex[1])
		print("db[ind] : ",serialize(db[2]))
		if db[listIndex[1]].Aliases == nil then
			db[listIndex[1]].Aliases={}
		end
		print("aliases : ",serialize(db[2]))
	
		table.insert(db[listIndex[1]].Aliases,al)
	end
	-- print(" at the end : ", serialize(db))
	

end

-- print("DB ", serialize(db))
-- On met le tout dans un fichier
local out_file = io.open("../Database_Characters.lua", "w")
out_file:write("return ")
out_file:write(serialize(db))
out_file:close()	
	
	
	
-------------------------------------------------------------
------------------------- TESTS -----------------------------
-------------------------------------------------------------

-- local seq1 = dark.sequence("Bran Stark , born at the castle of Winterfell in 290 AC , did nothing to Jon Snow but Theon of the Stark had his dick cut Oo !! Jon is a Stark but not really . Brandon Stark , typically called Bran , is the second son of Lord Eddard Stark and Lady Catelyn Tully . He is one of the major POV characters in the books . He has four older siblings — Robb , Jon , Sansa , Arya — and one younger — Rickon . Like his siblings , he is constantly accompanied by his direwolf , Summer , with whom he shares a strong warg connection.[3] He is seven years old at the beginning of A Game of Thrones . In the television adaptation Game of Thrones he is played by Isaac Hempstead-Wright . An exemple of city : Morosh . And a funny example of the famous region of this thing : Iron Islands . And also an island Isle of Pigs .")

-- local seq = dark.sequence("Brandon Stark was a member of House Stark and a son of the legendary Bran the Builder . Some stories claim that King Uthor of the High Tower commissioned Bran the Builder to design the stone Hightower , while others claim it was instead Bran's son , Brandon . It is unknown if Brandon was a King of Winter . Lord of the Seven Kingdoms is the title claimed by the ruler of the Seven Kingdoms of Westeros , whose seat is the Red Keep in King's Landing . After landing at the mouth of the Blackwater Rush , Aegon the Conqueror was crowned by his sister Visenya as ' Aegon , First of His Name , King of All Westeros , and Shield of His People ' . Stannis Baratheon styles himself as King of Westeros .")

-- local seq = dark.sequence("Brandon Stark was a member of House Stark and a son of the legendary Bran the Builder . Some stories claim that King Uthor of the High Tower commissioned Bran the Builder to design the stone Hightower , while others claim it was instead Bran's son , Brandon . It is unknown if Brandon was a King of Winter . Lord of the Seven Kingdoms is the title claimed by the ruler of the Seven Kingdoms of Westeros , whose seat is the Red Keep in King's Landing . After landing at the mouth of the Blackwater Rush , Aegon the Conqueror was crowned by his sister Visenya as ' Aegon , First of His Name , King of All Westeros , and Shield of His People ' . Stannis Baratheon styles himself as King of Westeros .")


-- pipe(seq1)
-- pipe(seq)
-- print(seq1:tostring(tags))
-- print(seq:tostring(tags))

	
	
	-- db[character]=db[character] or {}
	-- db[character].Name =
	-- {
		-- Firstname = firstname,
		-- Surname = surname,
	-- }
	-- db[character].Alias=db[character].Alias or {}
	-- table.insert(db[character].Alias,alias)
-- end


-- print("\n\n\ndb: ",serialize(db))

-- local out_file = io.open("database.lua", "w")
-- out_file:write("return ")
-- out_file:write(serialize(db))
-- out_file:close()





-- local db2 = dofile("database.lua")

-- print(serialize(db2))

