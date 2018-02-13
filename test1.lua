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

pipe:pattern([[
		[#Character #Title?? (#FirstName|#NickName) (#House|#SurName)?]
]])
tags ={
	["#Castle"] = "cyan",
	["#House"] = "red",
	["#City"] = "green",
	["#Region"] = "yellow",
	["#Organization"] = "blue",
	["#Island"] = "magenta",
	["#FirstName"]= "magenta",
	["#Character"] = "yellow",
	["#NickName"] = "cyan",
	["#SurName"] = "green"
}
state ={}
dofile("BD_Characters_exemple.lua")

quitting = false
--fonction de chargement de la table voulue en fonction du tag voulu depuis la reponse et la base de donnée extraite de la reponse
function chargefromAnswer(pipedanswer, tabletofill, tag, databaseanswer)
	local ind =1
	while pipedanswer[tag][ind] ~=nil do
		tabletofill[ind] = ""
		local index =1
		while pipedanswer[tag][ind][index] ~=nil do
			local wrdex = pipedanswer[tag][ind][index]
			if wrdex ~= pipedanswer[tag][ind][index-1] then
				tabletofill[ind] = tabletofill[ind].." ".. databaseanswer[wrdex]
			end
			index = index+1
		end
		ind = ind +1
	end
end
--fonction de traitement de la reponse, elle ne rempli que les personnages pour le moment
function answerTreatment (context, status, answertotreat)
	context["pipedanswer"] = pipe(answertotreat:gsub("%p", " %0 "))
	context["base"] = {}
	if #context["pipedanswer"]["#Quit"] == 0 then
		for bit in answertotreat:gsub("%p", " punctuation "):gmatch("%w+") do context["base"][#context["base"]+1] = bit end
		local k=1
		print(context["pipedanswer"])
		if #context["pipedanswer"]["#Character"] ~= 0 then
		status["#Character"] = {}
		context["#Character"] = {}
		status["#Character"]["list"]= {}
		context["#Character"]["list"] = {}
		status["#Character"]["activated"] = true
		chargefromAnswer(context["pipedanswer"], context["#Character"]["list"], "#Character", context["base"])
		end
		return false
	else		
		return true
	end
end

print([[Hello, i'm AskA.S.O.I.A.F., your chatbot dedicated to A Song Of Ice And Fire.]])
print([[What can i do for you today ?]])
while quitting ~= true do
	local context = {}
	local interrogation =false
	answer = io.read()
	interrogation = answerTreatment(context, state, answer)
	quitting = context["pipedanswer"]["#Quit"] ~= 0
	if interrogation~=true then
		if context["#Character"]~=nil then
			print ("you asked about "..table.concat(context["#Character"]["list"], ", "))
			
		else
			print("i can only provide information about characters, and you asked about none of which i know. I'm sorry, i can not answer this question")
		end
		
	end

end

print("I'm glad that we could have a talk.")print("See you later.")print("And remember, Winter is Coming.")
	