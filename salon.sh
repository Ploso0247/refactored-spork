#! /bin/bash

echo -e "\n~~~~~ MY SALON ~~~~~\n\nWelcome to My Salon, how can I help you?\n"
PSQL="psql -t -A --username=freecodecamp --dbname=salon -c"
MAIN_MENU() {
  echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED
  SERVICE=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")
  if [[ -z $SERVICE ]]
  then
    echo -e "\nI could not find that service. What would you like today?"
    MAIN_MENU
  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CHECKPHONE=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")
    if [[ -z $CHECKPHONE ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      yes=$($PSQL "insert into customers (phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
      WHAT_TIME
    else
      CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")
      WHAT_TIME
    fi
  fi

}
WHAT_TIME() {
  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
  yes2=$($PSQL "insert into appointments (customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  SERVICE=$($PSQL "select name from services where service_id = '$SERVICE_ID_SELECTED'")
  echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
