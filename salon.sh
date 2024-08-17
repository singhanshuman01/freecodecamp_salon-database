#!/bin/bash

psq="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"


services() {
service=$($psq "select name,service_id from services")
echo $service
echo "$service" | while read name bar id
do 
  echo "$id) $name"
done

read SERVICE_ID_SELECTED

if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then
  echo "Enter a valid choice"
  services
else
  SERVICE_ID_SELECTED=$($psq "select service_id from services where service_id=$SERVICE_ID_SELECTED")

  if [[ -z $SERVICE_ID_SELECTED ]]
  then
    echo "Enter a valid choice"
    services

  else
    echo -e "\nEnter your phone number"
    read CUSTOMER_PHONE

    CUSTOMER_ID=$($psq "select customer_id from customers where phone='$CUSTOMER_PHONE'")

    if [[ -z $CUSTOMER_ID ]]
    then
      echo -e "\nEnter your name"
      read CUSTOMER_NAME

      INSERT=$($psq "insert into customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")

    fi

    CUSTOMER_ID=$($psq "select customer_id from customers where phone='$CUSTOMER_PHONE'")
    CUSTOMER_NAME=$($psq "select name from customers where customer_id=$CUSTOMER_ID")


    echo -e "\nEnter the time"
    read SERVICE_TIME

    INSERT=$($psq "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

    SERVICE=$($psq "select name from services where service_id=$SERVICE_ID_SELECTED")

    if [[ $INSERT = "INSERT 0 1" ]]
    then
      echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME,$CUSTOMER_NAME."
    fi


  fi
fi

}

services

