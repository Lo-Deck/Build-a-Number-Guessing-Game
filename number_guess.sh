#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"



MAIN () {

  if [[ $1 ]]
  then
    echo $1
  fi

  echo -e "\nEnter your username: "

  read USERNAME

  if [[ -z $USERNAME ]]
  then
    MAIN "Please enter a name"
  else

    NAME_USERS=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME'")

    if [[ $USERNAME != $NAME_USERS ]]
    then
      echo -e "\nCreate a new player: "
      read NEW_PLAYER

      INSERT_NEW_PLAYER=$($PSQL "")

    else
      #player already existing

    fi

  fi


}

MAIN
