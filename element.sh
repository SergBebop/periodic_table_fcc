#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
  ARG=$1
  #Get Element
  if [[ "$ARG" =~ ^[0-9]+$ ]]
  then
    GET_ELEMENT=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types ON properties.type_id = types.type_id WHERE atomic_number=$ARG;")
  else
    GET_ELEMENT=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types ON properties.type_id = types.type_id WHERE LOWER(name) = LOWER('$ARG') OR LOWER(symbol) = LOWER('$ARG');")
  fi
  #Print element
  if [[ -z "$GET_ELEMENT" ]]
    then
      echo -e "I could not find that element in the database."
    else 
      echo "$GET_ELEMENT" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR MASS BAR MELTING BAR BOILING BAR TYPE
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
else
  echo "Please provide an element as an argument."
fi
