const functions = require('firebase-functions');

const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

var newData;

exports.messageTrigger = functions.firestore.document('Messages/{messageId}').onCreate(async (snapshot, context)=>{

  if(snapshot.empty)
  {
     console.log("No data");
     return;
  }

     var tokens = [];

     const deviceTokens = await admin.firestore().collection('DeviceTokens').get();

     for(var token of deviceTokens.docs)
     {
        if(token.data().device_token !== null && token.data().device_token !== "")
        {
           tokens.push(token.data().device_token);
        }


     }
     newData = snapshot.data();

     var payload = {
        notification: {title: 'Micgrand Resources Limited', body: 'Notification', sound: 'default'},
        data: {
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
        message: newData.message,
        },
     };

     const options = {
                 priority: 'high',
                 timeToLive: 60 * 60 * 24
           };

     try{
        const response = await admin.messaging().sendToDevice(tokens, payload, options);
        console.log("notifications sent successfully");
     }
     catch(err)
     {
        console.log(err);
     }


});