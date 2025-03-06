#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#insert unique teams to the teams tables and games data to the game table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #skip the first row
  if [[ $YEAR != year ]]
  then
    #get the teams id
    WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
    OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")

    #if winner team doesnt exits add it to the table
    if [[ -z $WINNER_ID ]]
    then
      #add team to the teams table
      RESPONSE=$($PSQL "insert into teams(name) values('$WINNER')")
      echo Added team: $WINNER

      #get the winner id
      WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
    fi

    #if opponent team doesnt exits add it to the table
    if [[ -z $OPPONENT_ID ]]
    then
      #add team to the teams table
      RESPONSE=$($PSQL "insert into teams(name) values('$OPPONENT')")
      echo Added team: $OPPONENT

      #get the new opponent id
      OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
    fi

    #add the game data
    RESPONSE=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    echo added game: $YEAR $WINNER V.S $OPPONENT
  fi
done