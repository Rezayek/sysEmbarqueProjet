import RPi.GPIO as GPIO
import time
from firebase_admin import credentials, firestore
import firebase_admin
cred = credentials.Certificate("syscontrollerapptp-firebase-adminsdk-vfulm-e28f044343.json")
firebase_admin.initialize_app(cred)
firestore_db = firestore.client()

#Set function to calculate percent from angle
def angle_to_percent (angle) :
    if angle > 180 or angle < 0 :
        return False

    start = 4
    end = 12.5
    ratio = (end - start)/180 #Calcul ratio from angle to percent

    angle_as_percent = angle * ratio

    return start + angle_as_percent


GPIO.setmode(GPIO.BOARD) #Use Board numerotation mode
GPIO.setwarnings(False) #Disable warnings

#Use pin 12 for PWM signal
pwm_gpio = 12
frequence = 50
GPIO.setup(pwm_gpio, GPIO.OUT)
pwm = GPIO.PWM(pwm_gpio, frequence)
while  True :
    docs = firestore_db.collection(u'fans').get()
    for doc in docs:
        isSpinning = doc.get('is_spinning')
    
    if(isSpinning):
        #Init at 0°
        pwm.start(angle_to_percent(0))
        time.sleep(1)

        #Go at 90°
        pwm.ChangeDutyCycle(angle_to_percent(90))
        time.sleep(1)

        #Finish at 180°
        pwm.ChangeDutyCycle(angle_to_percent(180))
        time.sleep(1)
        
    else:
        
        #Close GPIO & cleanup
        pwm.stop()
    
    time.sleep(1)
GPIO.cleanup()

