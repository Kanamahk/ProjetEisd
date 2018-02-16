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
pipe:lexicon("#Det", {"the"})
--Pattern Definitions

pipe:pattern([[
		[#Character #Title?? (#FirstName|#NickName) (#House|#SurName)?]
	]])
pipe:pattern([[
		[#Person (Who|who) #POS=VRB]
	]])
pipe:pattern([[
		[#Location (Where|where) #w. from]
	]])
pipe:pattern([[
		[#Co (to|To) #Character]
	]])
pipe:pattern([[
		[#Subject #POS=VRB #Character #POS=VRB?]
	]])
pipe:pattern([[
		[#Possess ((#Character "'" s | #Possessif) #w)|(#w of #Character)]
		]])
pipe:pattern([[
		[#Unprecised What (can|do) you (tell me|know) about #Character]
		]])
pipe:pattern([[
		[#Pers #Character|#Demonstratif|#Possessif|#Pronoun]
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
state["#Character"] = {}
state["#Character"]["Subject"]= ""
state["#Character"]["Co"] = ""
state["#Unprecised"] = false
--dofile("BD_Characters_exemple.lua")
pipe:lexicon("#Relation", {"father", "mother"})
Characters = {}
Characters["Barristan"] ={}
Characters["Barristan"]["Name"]={}
Characters["Barristan"]["Name"]["Firstname"]="Barristan"
Characters["Barristan"]["Name"]["Surname"]="Selmy"
Characters["Barristan"]["Relation"]={}
Characters["Barristan"]["Relation"]["father"]={} 
Characters["Barristan"]["Relation"]["father"]["FirstName"] = "Lyonel"
Characters["Barristan"]["Relation"]["father"]["Surname"] = "Selmy"
Characters["Barristan"]["Aliases"] = {}
Characters["Barristan"]["Aliases"] = {"Barristan the Bold", "Arstan Whitebeard", "Ser Grandfather", "Barristan the Old", "Old Ser"}
Characters["Barristan"]["titles"] ={}
Characters["Barristan"]["titles"]["current"] = {"Ser", "Hand of the Queen", "Lord Commander of the Queensguard of Queen Daenerys Targaryen"}
Characters["Barristan"]["titles"]["former"] = {"Lord Commander of the Kingsguard"}

pipe:lexicon("#QuestionMark", {"Who", "What", "Which", "Where", "When", "How", "Why"})
pipe:lexicon("#Aliases", {"called", "known as", "Alias", "NickName"})

quitting = false

function answerTreatment (context, status, answertotreat)
	context["pipedanswer"] = pipe(answertotreat:gsub("%p", " %0 "))
	context["base"] = {}
	if #context["pipedanswer"]["#Quit"] == 0 then
		for bit in answertotreat:gsub("%p", " punctuation "):gmatch("%w+") do context["base"][#context["base"]+1] = bit end
		local k=1
		print(context["pipedanswer"])
		if #context["pipedanswer"]["#Character"] ~= 0 then
			context["#Character"] = {}
			context["#Character"]["list"] = {}
			status["#Character"]["activated"] = true
			chargefromAnswer(context["pipedanswer"], context["#Character"]["list"], "#Character", context["base"], status["#Character"]["list"])
		end
		return false
	else		
		return true
	end
end
function InfoRetrieval()

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
	if #piped["#Possess"]>0 then
		local pos = piped:tag2str("#Possess")[1]
		if pos:find("of") then
			poswat = pos:sub(1, pos:find("of")-1):gsub("%s", "")
			print(wat)
		else
			if pos:find("' s") then
			t= ""..pos:find("' s")
			print (pos:find("' s")+0)
				poswat = pos:sub(pos:find("' s")+3):gsub("%s", "")
				print(wat)
			else
				if #piped["#Possessif"] ~=0 then
					poswat = pos:sub(pos:find(piped:tag2str("#Possessif")[1])+3):gsub("%s","")
				end
			end
		end
		reply = pos.." "
		reply = reply .. piped:tag2str("#POS=VRB")[1].." "
	end
	 -- print (Charac)
	if Charac then
		if piped:tag2str("#QuestionMark")[1]:lower() == "who" then 
			
			reply = reply .. Characters[Charac]["Relation"][poswat]["FirstName"].." ".. Characters[Charac]["Relation"][poswat]["Surname"].."."
			reply = reply:gsub("( )(%p )", "%2") 
		end
		if piped:tag2str("#QuestionMark")[1]:lower() == "how" then
			if #piped["#Aliases"] ~= 0 then
				 reply = reply .. table.concat(Characters[Charac]["Aliases"],", ")
			end
		end
		if piped:tag2str("#QuestionMark")[1]:lower() == "what" then
			
			reply = reply .. table.concat(Characters[Charac][poswat]["current"], ", ")
		end
	end
	print (reply)
end

print([[I'm glad that we could have a talk.
See you later.
And remember, Winter is Coming.]])
	