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
      GAMES_PLAYED=0
      BEST_GAME=0
    else
      #player already existing
      USER_DATA=$($PSQL "SELECT username, games_played, best_game FROM users WHERE username = '$USERNAME'")
      IFS='|' read USERNAME_FROM_DB GAMES_PLAYED BEST_GAME <<< "$USER_DATA" 
      echo -e "Welcome back, '$USERNAME_FROM_DB'! You have played $GAME_PLAYED games, and your best game took $BEST_GAME guesses."
    fi


    echo -e "Guess the secret number between 1 and 1000:"

    RANDOM_NUMBER=$(( RANDOM % 1000 + 1 ))


    USER_NUMBER=$(GUESS_NUMBER)


    NUMBER_TRIES=0


    while (( USER_NUMBER != RANDOM_NUMBER ))
    do

      (( NUMBER_TRIES++ ))

      if [[ $USER_NUMBER < $RANDOM_NUMBER ]]
      then
        USER_NUMBER=$(GUESS_NUMBER "It's lower than that, guess again: ")
      fi

      if [[ $USER_NUMBER > $RANDOM_NUMBER ]]
      then
        USER_NUMBER=$(GUESS_NUMBER "It's higher than that, guess again: ")
      fi

    done

    if [[ $USER_NUMBER == $RANDOM_NUMBER ]]
    then

      (( GAME_PLAYED++ ))

      if [[ $NUMBER_TRIES < $BEST_GAME ]]
      then
        BEST_GAME=$NUMBER_TRIES
      fi

      # INSERT_NEW_DATA=$($PSQL "INSERT INTO users(games_played, best_game) VALUES ($GAME_PLAYED, $NUMBER_TRIES)")
      INSERT_NEW_DATA=$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED, best_game = $NUMBER_TRIES WHERE username = '$USERNAME'")
      
      echo "You guessed it in $NUMBER_TRIES tries. The secret number was $USER_NUMBER. Nice job!"

    fi


  fi


}


GUESS_NUMBER () {

  if [[ $1 ]]
  then
    echo $1
  fi

  read USER_NUMBER

  if [[ ! $USER_NUMBER =~ ^[0-9]+$ ]] # && $USER_NUMBER <= 0
  then
    # echo -e "\nThat is not an integer, guess again:"
    GUESS_NUMBER "That is not an integer, guess again:"
  fi

  echo "$USER_NUMBER"

}


MAIN

