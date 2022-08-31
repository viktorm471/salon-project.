#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

  MAIN_MENU(){
    if [[ $1 ]]
      then
      echo $1
    fi  
      echo -e "\n HELLO, PICK THE SERVICE YOU WANT\n"
      echo "$($PSQL "SELECT * FROM services")" | while IFS="|" read NUM SERVICE
        do
        echo "$NUM) $SERVICE"
        done
      read SERVICE_ID_SELECTED
        SERVICE_EXIST=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
        #pick the service
        if [[ -z $SERVICE_EXIST ]]
          then
           #if the number its wrong 
           MAIN_MENU 
          else
            #if the number its right ask for the phone
            echo -e "\nPLEASE INTRODUCE YOUR PHONE NUMBER"
            read CUSTOMER_PHONE
            PHONE_EXIST=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
            #check the phone exist in db
              if [[ -z $PHONE_EXIST ]]
                then 
                echo -e "\n Please enter your name" 
                read CUSTOMER_NAME
                echo $($PSQL "INSERT INTO customers(name,phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")           
              fi
            echo -e "\n Choose the time you want"
            read SERVICE_TIME
            CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE' ")
             INSERT=$($PSQL "INSERT INTO appointments(time,customer_id,service_id) VALUES ('$SERVICE_TIME',$CUSTOMER_ID,'$SERVICE_ID_SELECTED')")
            
            CUSTOMER_NAME_FINAL=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
            echo -e "\nI have put you down for a $SERVICE_EXIST at $SERVICE_TIME, $CUSTOMER_NAME_FINAL."
        fi
  }
  MAIN_MENU