import RPi.GPIO as GPIO
import firebase_admin

from firebase_admin import credentials, firestore
import requests
from time import sleep
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)
GPIO.setup(8,GPIO.OUT,initial=GPIO.LOW)
GPIO.setup(37,GPIO.OUT,initial=GPIO.LOW)
cred = credentials.Certificate("syscontrollerapptp-firebase-adminsdk-vfulm-e28f044343.json")
firebase_admin.initialize_app(cred)
firestore_db = firestore.client()
while True:
    docs_1 = firestore_db.collection(u'lights').get()
    item=list()
    for doc in docs_1:
        item.append(doc.get('light'))
    if(item[0]):
         GPIO.output(37,GPIO.HIGH)
         sleep(1)
    else:
        GPIO.output(37,GPIO.LOW)
        sleep(1)
    print(item[0])    
    
    if(item[1]):
         GPIO.output(8,GPIO.HIGH)
         sleep(1)
    else:
        GPIO.output(8,GPIO.LOW)
        sleep(1)
