#!/bin/bash
## Подключение сетевого принтера локально

# Root or not
if  [ "$(id -u)" -ne 0 ] ; then
echo 'Not root'
else
	echo 'root'
fi

export LANG=C.UTF-8

f_version() {
    echo -e '
    Подключение локального принтера
    Version 1.0.0.3
'
}


choose_model() {

     while true; do
	read -p "Какой принтер устанавливаем? Введи цифры или часть названия: " model
        echo -e "\e[38;2;0;255;0mИщу ppt файлы. Подожди...\e[0m"	
	declare -a spisok
	spisok=(`lpinfo -m | grep $model | cut -d ' ' -f1 `)
	 m_count=${#spisok[*]}

	echo -e "\e[38;2;0;255;0mНайдено всего:  ${#spisok[@]} \e[0m"

	for zx in "${spisok[@]}"
	do 
		echo "$zx"
	done

        echo -e  "\e[38;2;0;255;0mВыбери файл или exit для выхода.\e[0m"

	select choice in "${spisok[@]}"  exit ; do
          if [[ $choice = "exit" ]]; then
              break 
          elif [[ " ${spisok[*]} " == *" $choice "* ]]; then
		p_model=$choice
              echo "Выбран принтер:   "; echo $p_model 
	      break
          else
              echo "invalid selection: "
          fi
	done

       	echo -e "\e[38;2;0;255;0mВыбран файл:  \e[0m" $p_model
	echo -e "\n"


	read -p " Продолжить выполнение (y/n)? " yn
        case $yn in
            [Yy]* ) echo '' ;  return 0; break;;
            [Nn]* ) exit;;
            * ) echo "Ответьте yes или no";;
        esac

     done

}



choose_name() {
	read -p "Введи имя принтера:    " printer_name

while true; do
	if grep -Pq '(^(?:[a-zA-Z0-9](?:(?:[a-zA-Z0-9\-\_]){0,61}[a-zA-Z0-9\-])?)+[a-zA-Z0-9]$)' <<< $printer_name
                then break; 
                else echo -e "\n \e[38;2;255;0;0mОшибка! Недопустимое имя принтера!\e[0m"
          exit;
	fi
  done

}


choose_ip()  {
        read -p "Ведитe IP:    " printer_ip

while true; do
	if grep -Pq '^(((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4})|(:[0-9]{1,5})$' <<< $printer_ip
                then break; 
                else echo -e "\n \e[38;2;255;0;0mОшибка! Недопустиый IP \e[0m "
          exit;
        fi
  done
}

choose_comment()  {


        read -p "Коментарий:    " printer_comment
        echo -e "\e[38;2;255;255;0mВыбрано:  "; echo "Printer Name:   $printer_name" ; echo "IP   $printer_ip"  ;echo "PTT file:   $p_model" ; echo "Comment: $printer_comment"; echo -e "\e[0m" 
	while true; do
	read -p " Продолжить выполнение (y/n)? " yn
        case $yn in
            [Yy]* ) return 0; break;;
            [Nn]* ) exit;;
            * ) echo "Ответьте yes или no";;
        esac
done

}



  

# Follow the white rabbit
  
  f_version
  choose_model
  choose_name
  choose_ip
  choose_comment


  
  echo -e "\e[38;2;0;255;0mПодключаю. Подожди...\e[0m"	

  echo "lpadmin -p $printer_name -E -v  \"socket://$printer_ip\" -m $p_model -L \"$printer_comment\""

  cmd="lpadmin -p $printer_name -E -v  \"socket://$printer_ip\" -m $p_model -L \"$printer_comment\""
  bash -c "$cmd"

  if [ $? -gt 0 ]
    then
      echo -e  "\e[38;2;255;5;0mWARNING: какая-то ошибка.\e[0m"
    else 
      echo -e  "\e[38;2;0;255;0mУспех!\e[0m"
  fi


