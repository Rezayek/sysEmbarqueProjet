import firebase_admin
import cv2
from firebase_admin import credentials, firestore
cap = cv2.VideoCapture(0)
detector = cv2.QRCodeDetector()
while True:
    _, img = cap.read()
    data, bbox, _ = detector.detectAndDecode(img)
    if bbox is not None:
        if data:
            print(data)
    if cv2.waitKey(1) == ord("q"):
        break

cap.release()
cv2.destroyAllWindows()
dataTab = data.split('__')
userId = dataTab[0]
system = dataTab[1]
id =''
cred = credentials.Certificate("syscontrollerapptp-firebase-adminsdk-vfulm-e28f044343.json")
firebase_admin.initialize_app(cred)
firestore_db = firestore.client()
docs = firestore_db.collection(u'users').where(u'user_id',u'==', userId,).get()

for doc in docs:
    id = doc.id

firestore_db.collection(u'users').document(id).update({u'user_access_'+system:True,})



