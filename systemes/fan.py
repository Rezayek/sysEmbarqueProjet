from gpiozero import Motor
from firebase_admin import credentials, firestore
import firebase_admin
cred = credentials.Certificate("syscontrollerapptp-firebase-adminsdk-vfulm-e28f044343.json")
firebase_admin.initialize_app(cred)
firestore_db = firestore.client()

#motor1 = Motor(4, 14)
while  True :
    docs = firestore_db.collection(u'fans').get()
    for doc in docs:
        isSpinnig = doc.get('is_spinning')
        if isSpinnig:
            #motor1.forward(0.4)
            print(isSpinnig)
            if doc.get('mode_1'):
                #motor1.forward(0.7)
                print("mode_1")
            elif doc.get('mode_2') :
                #motor1.forward(1)
                print("mode_2")
        else:
            #motor1.stop()  
            print("stop")      
