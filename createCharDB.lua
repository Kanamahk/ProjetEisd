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
pipe:pattern("[#date #d 'AC']")
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
------------------ DATABSE - FIRST STEP ---------------------
-------------------------------------------------------------

--On parcourt les fichiers contenus dans le dossier 
dirname='../FilesForDb'
f=io.popen(dirname.." dir") --/!\ Permission denied !!
for name in f:lines() do print(name) end


charIndex=dofile("../Database_CharIndex.lua") -- On récupère la BD si elle existe déjà
index = 1 -- A faire : Trouver comment définir l'index si charIndex existe déjà

file="../FilesForDb/Bran Stark.txt" --Fichier de test car problème avec le parcourt du dossier
path,filename,extension=string.match(file, "(.-)([^\\/]-%.?([^%.\\/]*))$") --on recupere le nom du fichier
filename=filename:gsub("[.]", " . ") --On met un espace de part et d'autre 

seq=pipe(filename)
if havetag(seq, "#character") then
	local character = GetValueInLink(seq, "#character","#character")
	local surname = GetValueInLink(seq, "#surname", "#character") or nil
--A faire : rajouter le nom de famille aussi
	if charIndex[character]==nil then
		charIndex[character] = {}
		table.insert(charIndex[character],index)
		index=index+1
	else 
		table.insert(charIndex[character],index)
		index=index+1
	end
end
print(" char ind ", serialize(charIndex))

--On met le tout dans un fichier
local out_file = io.open("../Database_CharIndex.lua", "w")
out_file:write("return ")
out_file:write(serialize(charIndex))
out_file:close()

-------------------------------------------------------------
------------------ DATABSE - SECOND STEP --------------------
-------------------------------------------------------------

--seq de test
local seq = dark.sequence("Brandon Stark was a member of House Stark and a son of the legendary Bran the Builder . Some stories claim that King Uthor of the High Tower commissioned Bran the Builder to design the stone Hightower , while others claim it was instead Bran's son , Brandon . It is unknown if Brandon was a King of Winter . Lord of the Seven Kingdoms is the title claimed by the ruler of the Seven Kingdoms of Westeros , whose seat is the Red Keep in King's Landing . After landing at the mouth of the Blackwater Rush , Aegon the Conqueror was crowned by his sister Visenya as ' Aegon , First of His Name , King of All Westeros , and Shield of His People ' . Stannis Baratheon styles himself as King of Westeros .")
pipe(seq)
print(seq:tostring(tags))

--Exemple de bd
local db = {
	[1]={
		Name={
			Firstname="fn",
			Surname="sn"
		},		
		Alias={"al"},		
		Titles={"tit"},		
		Allegiance={"alleg"},		
		Culture={"none"},		
		Born={
			Date={"date"},
			Place={"place"},
			House={"house"}
		},		
		Books={
			POV={"none"},
			Appearance={"none"},
			Mentioned={"non"}
		},		
		Gender="m",		
		Family={
			Parents={"2"},
			Siblings={"a lot"},
		},		
		Companions={"wolf"},		
		Looks={
			Skin="verry ghosty",
			Eyes="uggly",
			Hair="hairry"
		},		
		Passions={"die"},		
		Events={"live"}
	}
}


if havetag(seq, "#character") then
--on récupère les tags liés à #character
	local character = GetValueInLink(seq, "#character", "#character")
	local title = GetValueInLink(seq, "#title", "#character")
	local firstname = GetValueInLink(seq, "#firstname", "#character") or nil
	local alias = GetValueInLink(seq, "#alias", "#character") or nil 
	local surname  = GetValueInLink(seq, "#surname",   "#character") or nil
	
	print("\nchar: ",character, "\n\tfn: ",firstname," \n\tsn : ",surname, "\n\talias: ", alias)
	
--On part du postulat qu'on a une fiche sur tous les persos déjà 
	for i, char in ipairs(db) do
		print("\t", db[i].Name.Firstname, db[i].Name.Surname)
		if( firstname ~= db[i].Name.Firstname or surname ~= db[i].Name.Surname ) then
			-- A faire : Faire le lien avec la bd contenant les index
			
			db[character]=db[character] or {}
			db[character].Name =
			{
				Firstname = firstname,
				Surname = surname,
			}
			db[character].Alias=db[character].Alias or {}
			table.insert(db[character].Alias,alias)
			
		end
	end
end

print("DB ", serialize(db))
--On met le tout dans un fichier
local out_file = io.open("../Database_Characters.lua", "w")
out_file:write("return ")
out_file:write(serialize(db))
out_file:close()	
	
	
	
-------------------------------------------------------------
------------------------- TESTS -----------------------------
-------------------------------------------------------------

-- local seq1 = dark.sequence("Bran Stark , born at the castle of Winterfell in 290 AC , did nothing to Jon Snow but Theon of the Stark had his dick cut Oo !! Jon is a Stark but not really . Brandon Stark , typically called Bran , is the second son of Lord Eddard Stark and Lady Catelyn Tully . He is one of the major POV characters in the books . He has four older siblings — Robb , Jon , Sansa , Arya — and one younger — Rickon . Like his siblings , he is constantly accompanied by his direwolf , Summer , with whom he shares a strong warg connection.[3] He is seven years old at the beginning of A Game of Thrones . In the television adaptation Game of Thrones he is played by Isaac Hempstead-Wright . An exemple of city : Morosh . And a funny example of the famous region of this thing : Iron Islands . And also an island Isle of Pigs .")

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

