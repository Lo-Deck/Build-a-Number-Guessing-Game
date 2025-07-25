#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"



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

    NAME_USER=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME'")

    # if [[ $USERNAME != $NAME_USERS ]]
    if [[ -z $NAME_USER ]]
    then
      #create new player
      echo -e "Welcome, $USERNAME! It looks like this is your first time here."
      INSERT_NEW_PLAYER=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES ('$USERNAME', 0, 0)")
      # GAMES_PLAYED=0
      # BEST_GAME=0
    else
      #player already existing
      USER_DATA=$($PSQL "SELECT username, games_played, best_game FROM users WHERE username = '$USERNAME'")
      IFS='|' read USERNAME_FROM_DB GAMES_PLAYED BEST_GAME <<< "$USER_DATA" 
      echo -e "Welcome back, '$USERNAME_FROM_DB'! You have played $GAME_PLAYED games, and your best game took $BEST_GAME guesses."
    fi

    echo -e "Guess the secret number between 1 and 1000:"

    


  fi


}

MAIN
