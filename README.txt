Projet EISD

Participants : Pierre Genty, Tristan Hermant, Julie Richard, Bryan Vigée

Sujet : Création d'un "chatbot"


Points de discussion
	Comportement général du système
		•initiative utilisateur ? système ? mixte ?
		•demandes explicites de confirmation ? implicite ?
		•ordre et type des questions fixés ?
		
	Fonctionalités et indicateurs de compréhension
		•gestion de la communication ?
		•repérage des zones de non-compréhension ?
		•capacité à distinguer "je sais pas", "je ne comprends pas" ou encore  "je comprends X mais pas Y"
		
	Gestion de la communication	
		•Analyseur : repérage de certains actes de dialogue : opening, closing,  reject
		•Gestion du dialogue : prise en compte de ces actes de dialogue / indices pour compréhension en contexte, génération, fermeture de l’historique, etc.

	Repérage des zones de non-compréhension
		•Analyseur : différencier les segments connus des segments 	inconnus
		•Gestion du dialogue : répondre de façon approprié
		•relance ?	
	
	
Déroulement du syteme :

	web scrapper
		recuperation des pages sous forme de fichiers txt

	pre-traitements:
		traitements 1 : 
			remplissages des bds a partir des données structurées
		-> les entitées nommées sont récupérées
		
		traitements 2 :
			remplissage des bds a partir des données non-scruturées
			
		-> les bds sont constituées	
			
	système de dialogue :
		un moteur d’analyse des questions	
			similaire aux traitements 2
		un contrôleur de dialogue qui contrôle le flux du dialogue
		un module d’analyse contextuelle qui a en charge l’interprétation contextuelle des informations et la mise à jour de l’état du dialogue
		un module de génération de réponses (et questions etc.)

Trucs a part :
	Sauvegarder une bd :
		local out_file = io.open("../database.lua", "w")
		out_file:write("return ")
		out_file:write(serialize(db))
		out_file:close()
	
	Recuperer une bd :
		local db2 = dofile("../database.lua")


Tables :
	Infos Generales sur les livres (?)
	personnages
	maison/groupe/organisation/etc
	lieu/region/fort/cité/etc
	evenements
	action/peripetie
	?theories
		
Paterns:

Houses
Regions
People
Historical Event?
