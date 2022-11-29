#!/bin/bash
if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
else
  PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
  #
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$1
    QUERY=$($PSQL "SELECT symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
    echo $QUERY | while IFS="|" read SYMBOL NAME MASS MELTING BOILING TYPE
    do
      if [[ -z $NAME ]]
      then
        echo "I could not find that element in the database."
      else
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      fi
    done
  elif [[ ${#1} -lt 3 ]]
  then
    SYMBOL=$1
    QUERY=$($PSQL "SELECT atomic_number, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol='$SYMBOL'")
    echo $QUERY | while IFS="|" read ATOMIC_NUMBER NAME MASS MELTING BOILING TYPE
    do
      if [[ -z $NAME ]]
      then
        echo "I could not find that element in the database."
      else
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      fi
    done
  else
    NAME=$1
    QUERY=$($PSQL "SELECT atomic_number, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name='$NAME'")
    echo $QUERY | while IFS="|" read ATOMIC_NUMBER SYMBOL MASS MELTING BOILING TYPE
    do
      if [[ -z $ATOMIC_NUMBER ]]
      then
        echo "I could not find that element in the database."
      else
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      fi
    done
  fi
fi