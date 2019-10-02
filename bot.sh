#!/bin/bash

source ShellBot.sh

ShellBot.init --token $token --monitor --flush --return map
ShellBot.username

#_____ _   _ _   _  ____ ___  _____ ____  
#|  ___| | | | \ | |/ ___/ _ \| ____/ ___| 
#| |_  | | | |  \| | |  | | | |  _| \___ \ 
#|  _| | |_| | |\  | |__| |_| | |___ ___) |
#|_|    \___/|_| \_|\____\___/|_____|____/ 

unset btn_all 

btn_all='
["/set-targert","/nmap","/inurl"],
["/theharvester","/shodan","/whois"],
["karma","/sherlok","/pwnedornot"],
["/dorks","/admin","/commands","/show-target"]
'

btn_people='
["/karma","/sherlok","/pwnedornot"]
'
btn_infrastructure='
["/nmap","/inurl","/theharvester"],
["/shodan","/whois"] 
'

btn_target='["People 👨‍💻","Infrastructure 🖥"]'

btn_cleam='
["Cleam Target - People"],
["Cleam Target - Infrastructure"],
["Cleam All","Cleam Args"]
'

keyboard="$(ShellBot.ReplyKeyboardMarkup --button 'btn_all' --one_time_keyboard true)"
keyboard_infrastructure="$(ShellBot.ReplyKeyboardMarkup --button 'btn_nfrastructure' --one_time_keyboard true)"
keyboard_people="$(ShellBot.ReplyKeyboardMarkup --button 'btn_people' --one_time_keyboard true)"

while :
do

    ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
    for id in $(ShellBot.ListUpdates)
    do

	(
	[[ ${message_chat_type[$id]} != private ]] && continue
	mkdir /tmp/${message_from_id[$id]}
        target_dir=/tmp/${message_from_id[$id]}/target
        target_dir_p=/tmp/${message_from_id[$id]}/target_people
        target=$(< $target_dir)
	target_p=$(< $target_dir_p)
	arg_nmap_dir=/tmp/${message_from_id[$id]}/nmap-agr
	
	case ${message_text[$id]} in
		'/start')
        	 msg="Hi *$message_from_username* , Let's do a recon ? ?\n"
       	 	 msg+="Your frist time ? Go to /readme"
       		 ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
		 			--text "$(echo -e $msg)"		\
					--parse_mode markdown
		;;
		
		'/readme')
		msg=""
                ShellBot.sendMessage   --chat_id ${message_from_id[$id]}       \
                                        --text "$(echo -e $msg)"               \
                                        --parse_mode markdown
		;;	

		'/help')
        	 msg="Salve *$message_from_username* , Bora fazer um recon ?\n"
       	 	 msg+="Da uma olhada nas info em  /comandos."
       		 ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
		 			--text "$(echo -e $msg)"		\
					--parse_mode markdown
		;;

		"/nmap "*) 
		message_text=$(echo "$message_text" | awk '{print $2}') 
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
		                        --parse_mode markdown			\
					--text "Executing *NMAP* \\n Target = *$message_text* Wait =)"   
		nmap_result=$(nmap $message_text)
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "$nmap_result"  
		;; 

		'/nmap')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
				        --parse_mode markdown			\
					--text "Executing *NMAP* \\n Target = *$target* Wait =)"   
		nmap_result=$(nmap $target)
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "$nmap_result"  
		;;

		"/theharvester "*) 
		message_text=$(echo "$message_text" | awk '{print $2}') 
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--parse_mode markdown			\
					--text "Executing *The Harvester* \\n Target = *$message_text* Wait =)"   
		theharvester_result=$(theharvester -d $message_text -l 100 -b google)
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "$theharvester_result"  
		;;

		'/theharvester')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--parse_mode markdown			\
					--text "Executing *The Harvester* \\n Target = *$target* Wait =)"   
		theharvester_result=$(theharvester -d  $target -l 100 -b google)
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "$theharvester_result"  
		;;

		"/inurl "*)
		message_text=$(echo "$message_text" | awk '{print $2}') 
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "Dork - $message_text Aguarde =)"   
		inurl_result=$(inurl $message_text)
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "$inurl_result"  
		;;

		"/whois "*) 
		message_text=$(echo "$message_text" | awk '{print $2}') 
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--parse_mode markdown			\
					--text "Executing *Whois* \\n Target = *$message_text* Wait =)"   
		whois_result=$(whois $message_text)
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "$whois_result"  
		;;

		'/whois')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--parse_mode markdown			\
					--text "Executing *Whois* \\n Target = *$target* Wait =)"   
		whois_result=$(whois $target)
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "$whois_result"  
		;;

		'/shodan')
		shodan init $shodan_key
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--parse_mode markdown			\
					--text "Executing *Shodan* \\n Target = *$target* Wait =)"   
		shodan_result=$(shodan host $target)
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "$shodan_result"  
		;;

		"/shodan "*)
		shodan init $shodan_key
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--parse_mode markdown			\
					--text "Executing *Shodan* \\n Target = *$message_text* Wait =)"   
		shodan_result=$(shodan host $message_text)
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "$shodan_result"  
		;;

		'/karma')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--parse_mode markdown			\
					--text "Executing *Karma* \\n Target = *$target_p* Wait =)"   
		karma target $target_p > /tmp/karma.log
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "\`\`\`$(cat /tmp/karma.log) \\n \`\`\`" \
                                        --parse_mode markdown
		;;

		"/karma "*)
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--parse_mode markdown			\
					--text "Executing *Karma* \\n Target = *$message_text* Wait =)"   
		karma_result=$(karma target $message_text)
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "$karma_result"  
		;;

		'/sherlok')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--parse_mode markdown			\
					--text "Executing *Sherlok* \\n Target = *$target_p Wait =)"   
		/home/p0ssuidao/sherlock/sherlock.py $target_p | grep + > /tmp/sheklok.log
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "\`\`\`$(cat /tmp/sheklok.log) \`\`\`" 		\
                                        --parse_mode markdown
		;;

		"/sherlok "*)
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--parse_mode markdown			\
					--text "Executing *Sherlok* \\n Target = *$message_text* Wait =)"   
		sherlock_result=$(sherlock $message_text)
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "$sherlock_result"  
		;;

		'/pwnedornot')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--parse_mode markdown			\
					--text "Executing *Pwnedornot* \\n Target = *$target_p* Wait =)"   
		pwnedornot_result=$(pwnedornot.py -e $target)
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "$pwnedornot_result"  
		;;

		"/pwnedornot "*)	
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--parse_mode markdown			\
					--text "Executing *Pwnedornot* \\n Target = *$message_text* Wait =)"   
		pwnedornot_result=$(pwnedornot.py -e $message_text)
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "$pwnedornot_result"  
		;;


		'/dorks')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "Lista TOP DORKS"   
		dorks_result=$(cat dorks.list)
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "$dorks_result"  
		;;

		'/commands')
		msgp="For *People* \n"
		msgp+="/theharvester  -\n"
		msgp+="/karma - \n"
		msgp+="/pwnedornot - \n"
		msgp+="/sherlok - \n"
		msgi="For *Infrastructure* \n"
		msgi+="/nmap   - \n"
		msgi+="/shodan  - \n"
		msgi+="/inurl  - \n"	
		msgi+="/dorks  - \n"
		msgi+="/whois  - \n"
		msgt="To define your target \n"
		msgt+="/set-target - \n"
		msgt+="/show-target - \n"
		msgs="Alsos *Shotcuts* \n"
		msgs+="/btn-infrastructure - \n"
		msgs+="/btn-people - \n"
		msgs+="/btn-all - \n"
		msga="Set your args 4 commands \n"
		msga+="/advanced \n"
		msgc="Cleam confis \n"
		msgc+="/cleam"

		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]}	\
					--text "$(echo -e $msgp)"		\
					--parse_mode markdown
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]}	\
					--text "$(echo -e $msgi)"		\
					--parse_mode markdown
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]}	\
					--text "$(echo -e $msgt)"		\
					--parse_mode markdown
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]}	\
					--text "$(echo -e $msgs)"		\
					--parse_mode markdown
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]}	\
					--text "$(echo -e $msga)"		\
					--parse_mode markdown
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]}	\
					--text "$(echo -e $msgc)"		\
					--parse_mode markdown
		;;

		'/admin')
		message_text=$(echo "$message_text" | awk '{print $2,$3}') 
		$message_text > log 2> log
		ShellBot.sendMessage 	--chat_id $message_chat_id 		\
					--text "Comando executado"
		ShellBot.sendMessage 	--chat_id $message_chat_id 		\
					--text "$(echo -e "<b>log do comando $message_text</b>\n\n")" \
					--parse_mode html
		ShellBot.sendMessage 	--chat_id $message_chat_id 		\
					--text "$(cat log)"
		> log
		;;

		'/btn-all')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "All shortcuts" 		\
        				--reply_markup "$keyboard" 		\
					--parse_mode markdown
		;;

		'/btn-people')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "Shortcuts for peoples" 		\
        				--reply_markup "$keyboard_people" 	\
					--parse_mode markdown
		;;

		'/btn-infrastructure')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
					--text "Shortcurts for Infrastructure" 	\
        				--reply_markup "$keyboard_infrastructure" 	\
					--parse_mode markdown
		;;
		'/advanced')
		ShellBot.sendMessage	--chat_id ${message_from_id[$id]} 	\
					--text "For what command  ?" 		\
					--reply_markup "$(ShellBot.ForceReply)"
		;;

		'/set-target')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 		\
				     	--text "What target?"			\
					--reply_markup "$(ShellBot.ReplyKeyboardMarkup --button 'btn_target')" 
		;;

		'/show-infrastructure')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 		\
					--parse_mode markdown				\
				     	--text "Target = *$target*"
		;;

		'/show-people')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 		\
					--parse_mode markdown				\
				     	--text "Target = *$target_p*"
		;;

		*"People 👨‍💻"*)
		ShellBot.sendMessage	--chat_id ${message_from_id[$id]} 	\
					--text 'PEOPLE - What email or Username?' \
					--reply_markup "$(ShellBot.ForceReply)"
		unset btn_target 
		;;

		*"Infrastructure 🖥"*)
		ShellBot.sendMessage	--chat_id ${message_from_id[$id]}  	\
					--text 'INFRASTRUCTURE - What IP or domain?' \
					--reply_markup "$(ShellBot.ForceReply)"
		unset btn_target 
		;;

		'/cleam')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
				     	--text "What do you want to clean ?"		\
					--reply_markup "$(ShellBot.ReplyKeyboardMarkup --button 'btn_cleam')" 
		;;

		'Cleam Target - People')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
				     	--text "Target People cleam"		\
					--reply_markup "$(ShellBot.ReplyKeyboardRemove)" \
					--parse_mode markdown
		> $target_dir_p

		;;

		'Cleam Target - Infrastructure')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
				     	--text "Target Infrastructure cleam"		\
					--reply_markup "$(ShellBot.ReplyKeyboardRemove)" \
					--parse_mode markdown
		> $target_dir
		;;

		'Cleam All')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
				     	--text "All clear"			\
					--reply_markup "$(ShellBot.ReplyKeyboardRemove)" \
					--parse_mode markdown
		> $target_dir_p
		> $target_dir
		> $arg_nmap_dir
		;;

		'Cleam Args')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 	\
				     	--text "Args cleam"			\
					--reply_markup "$(ShellBot.ReplyKeyboardRemove)" \
					--parse_mode markdown
		> $arg_nmap_dir		
		;;

		'/keyoff')
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 		\
					--text "Removed"				\
					--reply_markup "$(ShellBot.ReplyKeyboardRemove)" \
					--parse_mode markdown
		;; 
		/*)	
		ShellBot.sendMessage 	--chat_id ${message_from_id[$id]} 		\
				     	--text "Invalid commands try /commands"

	esac

	if [[ ${message_reply_to_message_message_id[$id]} ]]; then
		case $message_text in
			"nmap"*)		
			ShellBot.sendMessage	--chat_id ${message_from_id[$id]} 	\
						--text "What args to NMAP" 	\
						--reply_markup "$(ShellBot.ForceReply)"
			;;
			'theharvester')
			ShellBot.sendMessage	--chat_id ${message_from_id[$id]} 	\
						--text 'What args to  HARVESTER' 			\
						--reply_markup "$(ShellBot.ForceReply)"
			;;
		esac
		case ${message_reply_to_message_text[$id]} in
			*"NMAP"*)
			echo $message_text > $arg_nmap_dir
			ShellBot.sendMessage	--chat_id ${message_from_id[$id]} 	\
						--text "seus args são $message_text" 	\
			;;

			*"target"*)
			echo $message_text > $target_dir
			ShellBot.sendMessage	--chat_id ${message_from_id[$id]} 	\
						--text "Target = $message_text" 	\
			;;
			'PEOPLE - What email or Username?')
			echo $message_text > $target_dir_p
			ShellBot.sendMessage	--chat_id ${message_from_id[$id]} 	\
						--text "Target = $message_text" 	\
        					--reply_markup "$keyboard_people" 	\
						--parse_mode markdown
			;;

			'INFRASTRUCTURE - What IP or domain?') 
			echo $message_text > $target_dir
			ShellBot.sendMessage	--chat_id ${message_from_id[$id]} 	\
						--text "Target = $message_text" 	\
        					--reply_markup "$keyboard_infrastructure" 	\
						--parse_mode markdown
			;;

		esac
	fi
	) &
	done
done
