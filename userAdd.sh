#!/bin/bash

############################################
#
# Name: userAdd.sh
#
#Author: Kaelan Baker
#
#Description:
#Reads in data from userdata.csv
#goes through each line to create a user
#
############################################

INPUTFILE="userdata.csv"

groupadd ITAS_YR1
groupadd ITAS_YR2

sed 1d $INPUTFILE | while IFS="," read -r rec_column1 rec_column2 rec_column3 rec_column4
do

#	Creating lowercase names for the users
	FNAME=$rec_column1
	FLOW=$(echo -n $FNAME |tr '[:upper:]' '[:lower:]')
	echo $FLOW
	LNAME=$rec_column2
	LLOW=$(echo $LNAME|tr '[:upper:]' '[:lower:]')
	echo $LLOW

#	Making Name comment field (Smith, John)

	LUPPER=$(echo ${LNAME:0:1}|tr '[lower]' '[upper]')
	FUPPER=$(echo ${FNAME:0:1}|tr '[lower]' '[upper]')

	CNAME=$(echo $LUPPER)$(echo ${LLOW:1})$(echo ", ")$(echo $FUPPER)$(echo ${FLOW:1})
	
	echo $CNAME
	
#	Creating birthday variables
	BDAY=$rec_column3
	DAY=${BDAY:0:2}
	MONTH=${BDAY:3:2}
	YEAR=${BDAY:6:2}
	echo $DAY
	echo $MONTH
	echo $YEAR
	
#	Making a year ID to work with for group permissions
	YR_ID=${rec_column4:5:1} 
	echo $YR_ID


#	Working with the variables set above to format username and password strings
	USERNAME=$(echo -n ${FLOW:0:1}$LLOW)
	echo $USERNAME

	PASSWD=$(echo -n ${FLOW:0:1}${LLOW:0:1}$YEAR$MONTH$DAY)
	echo $PASSWD

	DIRECTORY=$(echo "/home/"$USERNAME)
	echo $DIRECTORY


	if [ $YR_ID -eq 1 ]
	then
		NUID=1000
		NGID='ITAS_YR1'
		while id $NUID 1> /dev/null 2> /dev/null
		do
			NUID=$(($NUID + 1))
		done
	else
		NUID=2000
		NGID='ITAS_YR2'
		while id $NUID 1> /dev/null 2> /dev/null
                do
			NUID=$(($NUID + 1))
                done
	fi
	echo $NUID
	echo $NGID


	echo ""

#	Making users
	# pw_name: pw_password: pw_uid: pw_gid:   name_comment: directory:   shell
	# jstoneX:  jspasswdX:   1028:   ITAS_YR1: Stone, John: /home/jstone: /bin/bash

	# This didnt work, trying another way
	#newusers -r $USERNAME:$PASSWD:$NUID:$NGID:$CNAME:$DIRECTORY:/bin/bash

	useradd -m -d $DIRECTORY -c "$CNAME" -g $NGID -u $NUID $USERNAME
	echo $PASSWD |passwd --stdin $USERNAME

	echo ""

done

