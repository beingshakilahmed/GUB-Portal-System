#!/bin/bash

clear
figlet -f digital "WELCOME TO GUB PORTAL" -c | lolcat
echo "1.SIGN UP"
echo "2.LOG IN"
echo "3.ABOUT"
echo "4.EXIT"

signup() {
  figlet -f slant "SIGN UP" -c | lolcat
  echo "a.STUDENT SIGN UP"
  echo "b.TEACHER SIGN UP"
  echo "YOUR CHOICE BETWEEN a/b:"
  read cho
  if [ $cho == "a" ]; then
    echo "ENTER STUDENT ID: "
    read id
    echo "ENTER PASSWORD: "
    read password
    echo "$id:$password:student" >> users.txt
    echo "SIGNUP SUCCESSFUL! YOU CAN NOW LOG IN."
  elif [ $cho == "b" ]; then
    echo "ENTER USERNAME: "
    read username
    echo "ENTER PASSWORD: "
    read password
    echo "$username:$password:teacher" >> users.txt
    echo "SIGNUP SUCCESSFUL! YOU CAN NOW LOG IN."
  else
    echo "INVALID OPTION"
    signup
  fi
  main_menu
}

teacher() {
  clear
  figlet -f slant "TEACHER MENU" -c | lolcat
  echo "1.VIEW THE DATABASE"
  echo "2.VIEW SPECIFIC RECORDS"
  echo "3.ADD RESULT"
  echo "4.DELETE RESULT"
  echo "5.VIEW EVALUATION"
  echo "6.LOG OUT"
  echo "ENTER YOUR CHOICE:"
  read choice
  case $choice in
    1)
      cat $db
      echo "DO YOU WANT TO CONTINUE? "
      read i
      if [ $i == "yes" ]; then
        clear
        figlet -f digital "GUB PORTAL" -c | lolcat
        teacher
      fi
      ;;
    2)
      echo "ENTER STUDENT ID: "
      read id
      grep -i "$id" $db
      echo "DO YOU WANT TO CONTINUE?"
      read i
      if [ $i == "yes" ]; then
        clear
        figlet -f digital "GUB PORTAL" -c | lolcat
        teacher
      fi
      ;;
    3)
      echo "ENTER STUDENT ID: "
      read sid
      echo "ENTER NAME: "
      read snm
      echo "ENTER SEMESTER: "
      read semester
      echo "TOTAL NUMBER OF COURSES: "
      read num
      for ((i=1; i<=num; i++)); do
        read -p "ENTER COURSE-$i: " course[i]
      done
      for ((j=1; j<=num; j++)); do
        read -p "ENTER RESULT OF COURSE-$j: " result[j]
      done
      echo -e "STUDENT ID: $sid  STUDENT NAME: $snm  RESULT OF THE SEMESTER: $semester  TOTAL COURSE COMPLETED: $num  NAME OF THE COURSES: ${course[@]}  RESULT OF THE COURSES: ${result[@]}" >> $db
      echo "DO YOU WANT TO CONTINUE?"
      read i
      if [ $i == "yes" ]; then
        clear
        figlet -f digital "GUB PORTAL" -c | lolcat
        teacher
      fi
      ;;
    4)
      echo "ENTER ID: "
      read id
      grep -v "$id " $db > tmpfile && mv tmpfile $db
      echo "RECORD DELETED."
      cat $db
      echo "DO YOU WANT TO CONTINUE?"
      read i
      if [ $i == "yes" ]; then
        clear
        figlet -f digital "GUB PORTAL" -c | lolcat
        teacher
      fi
      ;;
    5)
      echo "ENTER TEACHER NAME: "
      read t_name
      grep -i "$t_name" $db
      echo "DO YOU WANT TO CONTINUE?"
      read i
      if [ $i == "yes" ]; then
        clear
        figlet -f digital "GUB PORTAL" -c | lolcat
        teacher
      fi
      ;;
    6)
      main_menu
      ;;
    *)
      echo "INVALID OPTION"
      teacher
      ;;
  esac
}

student() {
  clear
  figlet -f slant "STUDENT MENU" -c | lolcat
  echo "1.VIEW RESULT"
  echo "2.TEACHER EVALUATION"
  echo "3.PRE-REGISTRATION"
  echo "4.VIEW PRE-REGISTRATION"
  echo "5.LOG OUT"
  echo "ENTER YOUR CHOICE:"
  read choice
  case $choice in
    1)
      echo "ENTER STUDENT ID: "
      read id
      grep -i "$id" $db
      echo "DO YOU WANT TO CONTINUE?"
      read i
      if [ $i == "yes" ]; then
        clear
        figlet -f digital "GUB PORTAL" -c | lolcat
        student
      fi
      ;;
    2)
      echo "ENTER TEACHER NAME: "
      read t_name
      echo "ENTER SECTION: "
      read sec
      echo "ENTER COMMENTS: "
      read comments
      echo "ENTER DEPARTMENT NAME: "
      read dept
      echo "$t_name \t DEPARTMENT NAME: $dept \t COURSE SECTION: $sec \t COMMENTS: $comments" >> $db
      echo "DO YOU WANT TO CONTINUE?"
      read i
      if [ $i == "yes" ]; then
        clear
        figlet -f digital "GUB PORTAL" -c | lolcat
        student
      fi
      ;;
    3)
      echo "ENTER YOUR STUDENT ID: "
      read sid
      echo "ENTER NAME: "
      read snm
      echo "ENTER SECTION: "
      read section
      echo "HOW MANY COURSES YOU WANT TO TAKE: "
      read num
      for ((i=1; i<=num; i++)); do
        read -p "ENTER COURSE-$i: " course[i]
      done
      echo -e "STUDENT ID: $sid \t TOTAL COURSES TAKEN: $num \t SELECTED SECTION: $section \t SELECTED COURSES: ${course[@]}" >> $db_student.txt
      echo "DO YOU WANT TO CONTINUE?"
      read i
      if [ $i == "yes" ]; then
        clear
        figlet -f digital "GUB PORTAL" -c | lolcat
        student
      fi
      ;;
    4)
      echo "ENTER YOUR ID: "
      read id
      grep -i "$id" $db_student.txt
      echo "DO YOU WANT TO CONTINUE?"
      read i
      if [ $i == "yes" ]; then
      clear
      figlet -f digital "GUB PORTAL" -c | lolcat
      student
    fi
      ;;
    5)
      main_menu
      ;;
    *)
      echo "INVALID OPTION"
      student
      ;;
  esac
}

login() {
  figlet -f slant "LOG IN" -c | lolcat
  echo "a.STUDENT LOG IN"
  echo "b.TEACHER LOG IN"
  echo "YOUR CHOICE BETWEEN a/b:"
  read cho
  if [ $cho == "a" ]; then
    echo "ENTER STUDENT ID:"
    read id
    echo "ENTER PASSWORD: "
    read pass
    if grep -q "$id:$pass:student" users.txt; then
      echo "LOGIN SUCCESS!"
      echo "ENTER NAME OF DATABASE:"
      read db
      student
    else
      echo "LOGIN FAILED!"
    fi
  elif [ $cho == "b" ]; then
    echo "ENTER USERNAME:"
    read user
    echo "ENTER PASSWORD: "
    read password
    if grep -q "$user:$password:teacher" users.txt; then
      echo "LOGIN SUCCESS!"
      echo "ENTER NAME OF DATABASE:"
      read db
      teacher
    else
      echo "LOGIN FAILED!"
    fi
  else
    echo "INVALID OPTION"
    login
  fi
}

about() {
  figlet -f digital "PROJECT BY SHAKIL & MAHFUZ" -c | lolcat
    echo "DO YOU WANT TO CONTINUE? (yes/no)"
  read choice
  if [ $choice == "yes" ]; then
    main_menu
  fi
}

main_menu() {
  clear
  figlet -f digital "WELCOME TO GUB PORTAL" -c | lolcat
  echo "1.SIGN UP"
  echo "2.LOG IN"
  echo "3.ABOUT"
  echo "4.EXIT"
  echo "CHOOSE THE OPTION BETWEEN 1/2/3/4:"
  read choose
  case $choose in
    1)
      signup
      ;;
    2)
      login
      ;;
    3)
      about
      ;;
    4)
      exit
      ;;
    *)
      echo "INVALID OPTION"
      main_menu
      ;;
  esac
}

main_menu

