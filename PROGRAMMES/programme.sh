# *********************************************************************************************
# ** Script pour récupérer des URL contenus dans un fichier, les télécharger,                **
# ** les convertir en utf-8, si besoin, pluis les stocker dans des tableaux.	             **
# ** 																					     **
# ** Les tableaux contiennent 11 colonnes: n°, lien, code curl, statut curl, page aspirée,   **
# ** encodage initial, dump initial, dump utf-8, contexte utf-8 (txt), contexte utf-8 (html) **
# ** et freq motif	  																         **
# *********************************************************************************************

#!/bin/bash

# Suppression des anciens fichiers avant chaque lancement du script
#------------------------------------------------------------------
rm -r ../PAGES-ASPIREES/* ;
rm -r ../DUMP-TEXT/* ;
rm -r ../INDEX/* ;
rm -r ../CONTEXTES-TXT/* ;
rm -r ../CONTEXTES-HTML/* ;
rm -r ../FICHIERS-GLOBAUX/* ;
#------------------------------------------------------------------

# Exécution du fichier qui contient des chemins relatifs!
#--------------------------------------------------------
exec < ../parametres.txt; 
#--------------------------------------------------------

# Lecture du fichier ../parametres.txt
#-------------------------------------
read DOSSIERURLS ;
read fichier_tableau;
read motif;
#-------------------------------------

# Affichage à l'écran
#----------------------------------------------------------
echo "Le dossier d'URLs : $DOSSIERURLS " ;
echo "Le fichier contenant le tableau : $fichier_tableau" ;
echo "Le motif cherché: $motif" ;
#----------------------------------------------------------

# Création d'un tableau dans un fichier .html
#-----------------------------------------------------------------------------------------------------------------------------------------------------

# Incrémentation de la valeur 1 à la variable cpttableau
#-------------------------------------------------------
cpttableau=1;
#-------------------------------------------------------

# Ouverture de la balise <html>
# Insertion de la balise <meta charset> dans <head> pour l'encodage utf-8!
#-------------------------------------------------------------------------
echo "<html><head><meta charset=utf-8>" > $fichier_tableau ; 
#-------------------------------------------------------------------------

# Ajout d'une feuille de style CSS (interne) dans <head> pour changer la mise en forme du tableau
#----------------------------------------------------------------------------------------------------------------------------------------------------
echo "<link href=\"https://cdn.datatables.net/select/1.2.0/css/select.jqueryui.min.css\" rel=\"stylesheet\" type=\"text/css\">" >> $fichier_tableau ;
echo "<style>" >> $fichier_tableau ;
echo "table { " >> $fichier_tableau ;
echo "border-collapse: collapse; text-align: center; " >> $fichier_tableau ;
echo "padding: 1px 10px;" >> $fichier_tableau ;
echo "}" >> $fichier_tableau ;
echo "tr:nth-child(1) {" >> $fichier_tableau ;
echo "background-color: #7199ff;" >> $fichier_tableau ;
echo "font-size: 20px;" >> $fichier_tableau ;
echo "color: white;" >> $fichier_tableau ;
echo "}" >> $fichier_tableau ;
echo "th, td {" >> $fichier_tableau ;
echo "padding: 10px;" >> $fichier_tableau ;
echo "text-align: center;" >> $fichier_tableau ;
echo "}" >> $fichier_tableau ;
echo "tr:nth-child(even) {" >> $fichier_tableau ;
echo "background-color: AliceBlue" >> $fichier_tableau ;
echo "}" >> $fichier_tableau ;
echo "</style>" >> $fichier_tableau ;
#----------------------------------------------------------------------------------------------------------------------------------------------------

echo "</head>" >> $fichier_tableau ;
echo "<body>" >> $fichier_tableau ;
#-----------------------------------------------------------------------------------------------------------------------------------------------------

# Une premier boucle for pour chaque fichier d'URL
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
for fichier in `ls $DOSSIERURLS` 
{ 
	# Initialisation d'un compteur pour compter les URL
	# Incrémentation de la valeur 1 à la variable 'compteur'
	#-------------------------------------------------------
	compteur=1; 
	#-------------------------------------------------------
	
	# Initialisation d'un compteur pour compter les DUMPs
	# Incrémentation de la valeur 1 à la variable 'nbdump'
	#-----------------------------------------------------
	nbdump=0;
	#-----------------------------------------------------
	
	# Mise en page et création du tableau
	#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    echo "<p align=\"center\"><hr color=\"blue\" width=\"95%\"/> </p>" >> $fichier_tableau ; # mise en page 
    echo "<table id=\"example\" class=\"display\" align=\"center\" cellspacing=\"1\" width=\"90%\">" >> $fichier_tableau ; # mise en page 
	
	# Création du chaque tableau avec un titre différent (selon la langue des URL traités)
	#----------------------------------------------------------------------------------------------------------------------------------------
	case $fichier in
	URL_AR.txt) echo "<tr><td colspan=\"12\" align=\"center\"><b>Tableau n° $cpttableau - <u>Arabe</u></b></td></tr>" >> $fichier_tableau ; 
	;;
	URL_EN.txt) echo "<tr><td colspan=\"12\" align=\"center\"><b>Tableau n° $cpttableau - <u>Anglais</u></b></td></tr>" >> $fichier_tableau ; 
	;;
	URL_FR.txt) echo "<tr><td colspan=\"12\" align=\"center\"><b>Tableau n° $cpttableau - <u>Français</u></b></td></tr>" >> $fichier_tableau ; 
	;;
	URL_GR.txt) echo "<tr><td colspan=\"12\" align=\"center\"><b>Tableau n° $cpttableau - <u>Grec</u></b></td></tr>" >> $fichier_tableau ; 
	;;
	URL_KR.txt) echo "<tr><td colspan=\"12\" align=\"center\"><b>Tableau n° $cpttableau - <u>Coréen</u></b></td></tr>" >> $fichier_tableau ; 
	;;
	URL_TR.txt) echo "<tr><td colspan=\"12\" align=\"center\"><b>Tableau n° $cpttableau - <u>Turc</u></b></td></tr>" >> $fichier_tableau ; 
	;;
	esac
	#----------------------------------------------------------------------------------------------------------------------------------------
	
    echo "<tr><td align=\"center\" width=\"4%\"><b>N°</b></td><td align=\"center\" width=\"8%\"><b>URL</b></td><td align=\"center\" width=\"3%\"><b>CODE CURL</b><td align=\"center\" width=\"12%\"><b>statut CURL</b></td><td align=\"center\" width=\"10%\"><b>P.A.</b></td><td align=\"center\" width=\"8%\"><b>Encodage Initial</b></td><td align=\"center\" width=\"10%\"><b>DUMP initial</b></td><td align=\"center\" width=\"11%\"><b>DUMP UTF-8</b></td><td align=\"center\" width=\"13%\"><b>Contexte UTF-8 (txt)</b></td></td><td align=\"center\" width=\"13%\"><b>Contexte UTF-8 (html)</b></td><td align=\"center\" width=\"3%\"><b>Freq MOTIF</b></td><td align=\"center\" width=\"5%\"><b>Index DUMP</b></td></tr>" >> $fichier_tableau ; # titre des colonnes du tableau
	#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Une deuxième boucle for pour chacune des lignes du fichier d'URL traité
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
for line in `cat $DOSSIERURLS/$fichier`  
    {
		# Aspiration de la page web
		#---------------------------------------------------------------------------------
		echo "TELECHARGEMENT de $line vers ../PAGES-ASPIREES/$cpttableau-$compteur.html" ;
		curl $line -o ../PAGES-ASPIREES/$cpttableau-$compteur.html;
		#---------------------------------------------------------------------------------
		
		echo "CODE RETOUR CURL : $?" ; # ceci doit être 0 pour annoncer que tout va bien
		
		# Récuperation du HEADER HTTP - affiche la première ligne du statut d'URL
		#------------------------------------------------------------------------
		status1=$(curl -sI $line | head -n 1); 
		#------------------------------------------------------------------------
		
		# Récuperation du code retour http de la page - affiche le statut CURL
		#---------------------------------------------------------------------------------------------------------------
		status2=$(curl --silent --output ../PAGES-ASPIREES/$cpttableau-$compteur.html --write-out "%{http_code}" $line);
		echo "STATUT CURL : $status2" ;
		#---------------------------------------------------------------------------------------------------------------
		
		# Première boucle if
		# Vérification: Si le statut est correct, c'est-à-dire si le téléchargement s'est bien passé, on exécute les commandes suivantes
		#------------------------------------------------------------------------------------------------------------------------------
		if [[ $status2 = "200" ]] 
			then
				echo "La commande curl s'est bien passée, on continue" ;
				
				# Récuperation de l'encodage - avec la commande file!
				#------------------------------------------------------------------------------
				encodage=$(file -i ../PAGES-ASPIREES/$cpttableau-$compteur.html | cut -d= -f2);
				echo "Encodage intitial récupéré : $encodage" ;
				#------------------------------------------------------------------------------
	
				# Deuxième boucle if, qui décrit les étapes à suivre selon le cas:
				# L'encodage initial est bien d'utf-8, donc on lance les commandes suivantes:
				#----------------------------------------------------------------------------
				if [[ $encodage == "utf-8" ]] 
					then 
						echo "DUMP de $line via lynx" ;
						
						# Commande lynx pour dump(er) le contenu
						#---------------------------------------------------------------------------------------------------------------------------------------------------------
						lynx -dump -nolist -assume_charset=$encodage -display_charset=$encodage ../PAGES-ASPIREES/$cpttableau-$compteur.html > ../DUMP-TEXT/$cpttableau-$compteur-initial.txt ; 
						#---------------------------------------------------------------------------------------------------------------------------------------------------------

						# Commande pour "nettoyer" un peu le DUMP
						#-----------------------------------------------------------------------------------------------------------------------------------------
						cat ../DUMP-TEXT/$cpttableau-$compteur-initial.txt | bash ../process_sed.bash > ../DUMP-TEXT/$cpttableau-$compteur-initial-sed.txt ;
						#-----------------------------------------------------------------------------------------------------------------------------------------
						
						# Ici on cherche $motif avec egrep en ignorant les majuscules (-i) et on l'insère dans un fichier texte			
						#-------------------------------------------------------------------------------------------------------------
						egrep -i $motif ../DUMP-TEXT/$cpttableau-$compteur-initial-sed.txt >> ../CONTEXTES-TXT/$cpttableau-$compteur.txt ;
						#-------------------------------------------------------------------------------------------------------------

						# On compte le nombre d'occurrences du motif dans le fichier ../CONTEXTES/$cpttableau-$compteur.txt
						# en comptant (-c) les occurrences (-o) et en ignorant les majuscules (-i)
						#--------------------------------------------------------------------------------------------------
						nbmotif=$(egrep -coi $motif ../CONTEXTES-TXT/$cpttableau-$compteur.txt);
						#--------------------------------------------------------------------------------------------------
						
						# Utilisation du programmme "minigrep"
						#----------------------------------------------------------------------------------------------------------------------------------------------
						perl ../minigrepmultilingue-html/minigrepmultilingue.pl "utf-8" ../DUMP-TEXT/$cpttableau-$compteur-initial-sed.txt ../minigrepmultilingue-html/motif-regexp.txt ; 
						mv resultat-extraction.html ../CONTEXTES-HTML/$cpttableau-$compteur-utf8.html ;
						#----------------------------------------------------------------------------------------------------------------------------------------------
						
						# Création d'une page Index
						#--------------------------------------------------------------------------------------------------------------------------------------------
						egrep -o "\w+" ../DUMP-TEXT/$cpttableau-$compteur-initial-sed.txt | sort | uniq -c | sort -r > ../INDEX/index-$cpttableau-$compteur.txt ;
						#--------------------------------------------------------------------------------------------------------------------------------------------
						
						# Affichage des résultats dans le tableau:						
						#-------------------------------------------------------------------------------------------------------------------------------------------------------
						echo "Ecriture des RESULTATS dans le tableau" ;
						echo "<tr><td align=\"center\">$compteur</td><td align=\"center\"><a href=\"$line\">URL n°$compteur</a></td><td align=\"center\">$status2</td><td align=\"center\"><small>$status1</small></td><td align=\"center\"><a href=\"../PAGES-ASPIREES/$cpttableau-$compteur.html\">P.A n°$compteur</a></td><td align=\"center\">$encodage</td><td align=\"center\">-</td><td align=\"center\"><a href=\"../DUMP-TEXT/$cpttableau-$compteur-initial-sed.txt\">DUMP n°$compteur</a></td><td align=\"center\"><a href=\"../CONTEXTES-TXT/$cpttableau-$compteur.txt\">Contexte n°$compteur</a></td><td align=\"center\"><a href=\"../CONTEXTES-HTML/$cpttableau-$compteur-utf8.html\">Contexte n°$compteur</a></td><td align=\"center\">$nbmotif</td><td align=\"center\"><a href=\"../INDEX/index-$cpttableau-$compteur.txt\">$Index n°$compteur</a></td></tr>" >> $fichier_tableau;
						#-------------------------------------------------------------------------------------------------------------------------------------------------------
						
						# Il faut ajouter 1 au compteur de DUMPs
						#---------------------------------------
						let "nbdump += 1" ;
						#---------------------------------------

						# Création d'un DUMP global et d'un Contexte global
						#----------------------------------------------------------------------------------------------------------
						echo "<file=$nbdump>" >> ../FICHIERS-GLOBAUX/CONTEXTE-Global_$cpttableau.txt ;
						echo "<file=$nbdump>" >> ../FICHIERS-GLOBAUX/DUMP-Global_$cpttableau.txt ;
						cat ../CONTEXTES-TXT/$cpttableau-$compteur.txt >> ../FICHIERS-GLOBAUX/CONTEXTE-Global_$cpttableau.txt ;
						cat ../DUMP-TEXT/$cpttableau-$compteur-initial-sed.txt >> ../FICHIERS-GLOBAUX/DUMP-Global_$cpttableau.txt ;
						#----------------------------------------------------------------------------------------------------------

						
					else
						# Selon la commande file, l'encodage initial n'est pas d'utf-8... 
						# Dans quelques cas, on n'a pas encore detecté l'encodage! 
						# Il faut trouver une solution... idée: 
						# Aller chercher le charset dans la page aspirée afin de récupérer l'encodage! 
						# Donc, on va chercher le charset avec egrep. (En utilisant cut on ne garde QUE l'encodage!)
						#-------------------------------------------------------------------------------------------
						
						# On vérifie s'il y a bien un charset...
						#------------------------------------------------------------------------
						if egrep -i "<meta.*charset" ../PAGES-ASPIREES/$cpttableau-$compteur.html
						#------------------------------------------------------------------------
							then
								# Récupération d'encodage en ignorant la case (on utilise la commande tr pour changer tous les caractères en minuscules) 
								# et en 'supprimant' les guillemets (on utilise la commande sed; on change le symbole " avec une espace)
								#--------------------------------------------------------------------------------------------------------------------------------------------------
								encodage2=$(egrep -i "<meta.*charset" ../PAGES-ASPIREES/$cpttableau-$compteur.html | egrep -io 'charset ?=\"?[^\"]+\"?' | tr [A-Z] [a-z]] | sort -u | cut -d= -f2 | sed -e "s/\"//g");
								echo "Encodage récupéré dans le charset : $encodage2 ";
								#--------------------------------------------------------------------------------------------------------------------------------------------------
						
								# Ici, on veut bien vérifier que l'encodage qu'on vient de récupérer est reconnu d'iconv!
								# sort -f : pour "ignorer" la case (f pour fold)
								# sort -u : pour supprimer les doublons
								# iconv -l : affiche la liste d'encodage connue par la commande iconv
								#----------------------------------------------------------------------------------------
								verification_encodage=$(iconv -l | egrep -o -i $encodage2 | sort -f -u);
								echo "Vérification de l'encodage dans iconv: $verification_encodage";
								#----------------------------------------------------------------------------------------
						
								# Si l'encodage n'est pas reconnu de la commande iconv...						
								#----------------------------------------------------------------------------------------------------------------------------------------
								if [[ $verification_encodage == "" ]]
									then
										echo "Encodage inconnu. On ne peut rien faire...";
										
										# Affichage des résultats dans le tableau:
										#------------------------------------------------------------------------------------------------------------------------------------------
										echo "Ecriture des RESULTATS dans le tableau" ;
										echo "<tr><td align=\"center\">$compteur</td><td align=\"center\"><a href=\"$line\">URL n°$compteur</a></td><td align=\"center\">$status2</td><td align=\"center\"><small>$status1</small></td><td align=\"center\"><a href=\"../PAGES-ASPIREES/$cpttableau-$compteur.html\">P.A n°$compteur</a></td><td align=\"center\">$encodage</td><td align=\"center\">DUMP n°$compteur non fait</td><td align=\"center\">-</td><td align=\"center\">-</a></td><td align=\"center\">-</a></td><td align=\"center\">-</td><td align=\"center\">-</td></tr>" >> $fichier_tableau;
								#--------------------------------------------------------------------------------------------------------------------------------------------------

								#Si l'encodage est reconnu de la commande iconv, mais il ne s'agit pas d'utf-8...						
								#--------------------------------------------------------------------------------------------------------------------------------------------------	
									else
										# Si on arrive à trouver un encodage quelconque, on doit d'abord faire un lynx -dump, 
										# puis le transcoder en utf-8 (on le sauvegarde dans un autre fichier),
										# et enfin trouver le motif qu'on cherche, et aussi son contexte!
								
										# Commande lynx pour DUMP le contenu								
										#-------------------------------------------------------------------------------------------------------------------------------------
										echo "DUMP de $line via lynx" ;
										lynx -dump -nolist -assume_charset=$encodage2 -display_charset=$encodage2 ../PAGES-ASPIREES/$cpttableau-$compteur.html > ../DUMP-TEXT/$cpttableau-$compteur-initial.txt ;
										#-------------------------------------------------------------------------------------------------------------------------------------
										
										# Commande iconv pour le transcodage; conversion de l'encodage trouvé, en utf-8								
										#--------------------------------------------------------------------------------------------------------------------------
										iconv -f $encodage2 -t UTF-8 ../DUMP-TEXT/$cpttableau-$compteur-initial.txt > ../DUMP-TEXT/$cpttableau-$compteur-utf8.txt ; 
										#--------------------------------------------------------------------------------------------------------------------------
										
										# Commande pour "nettoyer" un peu le DUMP
										# Ce petit programme qu'on appelle, ne contient qu'une seule commande: sed
										#-------------------------------------------------------------------------------------------------------------------------
										cat ../DUMP-TEXT/$cpttableau-$compteur-utf8.txt | bash ../process_sed.bash > ../DUMP-TEXT/$cpttableau-$compteur-utf8-sed.txt ;
										#-------------------------------------------------------------------------------------------------------------------------

										# Encore une fois, on répète ce qu'on a fait auparavant, vu que l'encodage est maintenant d'utf-8 !
										# On cherche $#motif avec egrep en ignorant les majuscules (-i) et on l'insère dans une variable
										#---------------------------------------------------------------------------------------------------------------
										egrep -i $motif ../DUMP-TEXT/$cpttableau-$compteur-utf8-sed.txt >> ../CONTEXTES-TXT/$cpttableau-$compteur-utf8.txt ;
										#---------------------------------------------------------------------------------------------------------------
								
										# Compter le nombre d'occurrences du motif dans le fichier ../CONTEXTES/$cpttableau-$compteur-utf8.txt
										# en comptant (-c) les occurrences (-o) et en ignorant les majuscules (-i)
										#-----------------------------------------------------------------------------------------------------
										nbmotif=$(egrep -coi $motif ../CONTEXTES-TXT/$cpttableau-$compteur-utf8.txt);
										#-----------------------------------------------------------------------------------------------------
								
										# Utilisation du programmme "minigrep":
										#---------------------------------------------------------------------------------------------------------------------------------------
										perl ../minigrepmultilingue-html/minigrepmultilingue.pl "utf-8" ../DUMP-TEXT/$cpttableau-$compteur-utf8.txt ../minigrepmultilingue-html/motif-regexp.txt ;
										mv resultat-extraction.html ../CONTEXTES-HTML/$cpttableau-$compteur-utf8.html ;
										#---------------------------------------------------------------------------------------------------------------------------------------
										
										# Création d'une page Index
										#------------------------------------------------------------------------------------------------------------------------------------
										egrep -o "\w+" ../DUMP-TEXT/$cpttableau-$compteur-utf8.txt | sort | uniq -c | sort -r > ../INDEX/index-$cpttableau-$compteur.txt;
										#------------------------------------------------------------------------------------------------------------------------------------
										
										# Affichage des résultats dans le tableau:									#-----------------------------------------------------------------------------------------------------------------------------------------
										echo "Ecriture des RESULTATS dans le tableau" ;
										echo "<tr><td align=\"center\">$compteur</td><td align=\"center\"><a href=\"$line\">URL n°$compteur</a></td><td align=\"center\">$status2</td><td align=\"center\"><small>$status1</small></td><td align=\"center\"><a href=\"../PAGES-ASPIREES/$cpttableau-$compteur.html\">P.A n°$compteur</a></td><td align=\"center\">$encodage</td><td align=\"center\"><a href=\"../DUMP-TEXT/$cpttableau-$compteur-initial.txt\">DUMP n°$compteur</a></td><td align=\"center\"><a href=\"../DUMP-TEXT/$cpttableau-$compteur-utf8-sed.txt\">DUMP n°$compteur</a></td><td align=\"center\"><a href=\"../CONTEXTES-TXT/$cpttableau-$compteur-utf8.txt\">Contexte n°$compteur</a></td><td align=\"center\"><a href=\"../CONTEXTES-HTML/$cpttableau-$compteur-utf8.html\">Contexte n°$compteur</a></td><td align=\"center\">$nbmotif</td><td align=\"center\"><a href=\"../INDEX/index-$cpttableau-$compteur.txt\">$Index n°$compteur</a></td></tr>" >> $fichier_tableau;
										#-----------------------------------------------------------------------------------------------------------------------------------------
										
										# Il faut ajouter 1 au compteur de DUMPs
										#---------------------------------------
										let "nbdump += 1" ;
										#---------------------------------------
							
										# Création d'un DUMP global et d'un Contexte global
										#-------------------------------------------------------------------------------------------------------
										echo "<file=$nbdump>" >> ../FICHIERS-GLOBAUX/CONTEXTE-Global_$cpttableau.txt ;
										echo "<file=$nbdump>" >> ../FICHIERS-GLOBAUX/DUMP-Global_$cpttableau.txt ;
										cat ../CONTEXTES-TXT/$cpttableau-$compteur-utf8.txt >> ../FICHIERS-GLOBAUX/CONTEXTE-Global_$cpttableau.txt ;
										cat ../DUMP-TEXT/$cpttableau-$compteur-utf8.txt >> ../FICHIERS-GLOBAUX/DUMP-Global_$cpttableau.txt ;
										#-------------------------------------------------------------------------------------------------------

										
								#--------------------------------------------------------------------------------------------------------------------------------------------------	
								fi # Fin de la boucle pour la commande iconv (encodage reconnu ou pas)
							
							# S'il n'y a pas de charset...
							# ------------------------------------------------
							else 
								echo "Il n'y a pas un charset à récupérer...";
							# ------------------------------------------------
							
						fi # Fin de la boucle pour la vérification et/ou récupération d'un charset
					
				fi # Fin de la boucle pour les pages encodées en utf-8
				
			# Un problème était renconté lors du téléchargement de la page...
			#-----------------------------------------------------------------------------------
			else
				echo "Il y avait une erreur lors du téléchargement de la page! On ne fait rien";
			#-----------------------------------------------------------------------------------

		fi # Fin de la boucle pour la vérification du téléchargement de la page
		
	# Il faut ajouter 1 au compteur de lignes	
	#--------------------------------------------------------
	let "compteur = compteur + 1 ";  # == let "compteur += 1"
	#--------------------------------------------------------
	
	} # Fermeture de la boucle for (pour chaque URL)

#Ajout dans le tableau d'"Index DUMP Global" et d'"Index CONTEXTES Global"
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
egrep -o "\w+" ../FICHIERS-GLOBAUX/DUMP-Global_$cpttableau.txt | sort | uniq -c | sort -r > ../FICHIERS-GLOBAUX/index-DUMP-Global_$cpttableau.txt ;
egrep -o "\w+" ../FICHIERS-GLOBAUX/CONTEXTE-Global_$cpttableau.txt | sort | uniq -c | sort -r > ../FICHIERS-GLOBAUX/index-CONTEXTE-Global_$cpttableau.txt ;

echo "<tr><td align=\"center\" colspan=\"7\">&nbsp</td><td align=\"center\" width=\"100\"><a href=\"../FICHIERS-GLOBAUX/DUMP-Global_$cpttableau.txt\">Fichier DUMP<br/>global</a><br/><small>$nbdump fichier(s)</small></td><td align=\"center\" width=\"100\"><a href=\"../FICHIERS-GLOBAUX/CONTEXTE-Global_$cpttableau.txt\">Fichier CONTEXTES<br/>global</a><br/><small>$nbdump fichier(s)</small></td><td colspan=\"3\"></td></tr>" >> $fichier_tableau;

echo "<tr><td align=\"center\" colspan=\"7\">&nbsp</td><td align=\"center\" width=\"100\"><a href=\"../FICHIERS-GLOBAUX/index-DUMP-Global_$cpttableau.txt\">Index DUMP<br/>global</a><br/><small>$nbdump fichier(s)</small></td><td align=\"center\" width=\"100\"><a href=\"../FICHIERS-GLOBAUX/index-CONTEXTE-Global_$cpttableau.txt\">Index CONTEXTES<br/>global</a><br/><small>$nbdump fichier(s)</small></td><td colspan=\"3\"></td></tr>" >> $fichier_tableau;
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
# Fermeture de la balise <table> qui a été ouverte à la ligne 99
#---------------------------------------------------------------
echo "</table>" >> $fichier_tableau ;
#---------------------------------------------------------------

# Il faut ajouter 1 au compteur de tableaux
#-------------------------------------------------------------
let "cpttableau = cpttableau + 1" ; # == let "cpttableau += 1"
#-------------------------------------------------------------

} # Fermeture de la boucle for (pour chaque fichier)

# Fermeture de la balise <html> qui a été ouverte à la ligne 50
# Fermeture de la balise <body> qui a été ouverte à la ligne 77
#--------------------------------------------------------------
echo "</body></html>" >> $fichier_tableau ;
#--------------------------------------------------------------