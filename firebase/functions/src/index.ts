import * as functions from "firebase-functions";
import * as admin from “firebase-admin”;


admin.initializeApp({
credential: admin.credential.applicationDefault(),
});

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


// Listens for new messages added to /messages/:documentId/original and creates an
// uppercase version of the message to /messages/:documentId/uppercase
exports.makeUppercase = functions.firestore.document('/messages/{documentId}')
    .onCreate((snap, context) => {
      // Grab the current value of what was written to Firestore.
      const original = snap.data().original;

      // Access the parameter `{documentId}` with `context.params`
      functions.logger.log('Uppercasing', context.params.documentId, original);

      const uppercase = original.toUpperCase();

      // You must return a Promise when performing asynchronous tasks inside a Functions such as
      // writing to Firestore.
      // Setting an 'uppercase' field in Firestore document returns a Promise.
      return snap.ref.set({uppercase}, {merge: true});
    });


    export const notifyNewProtestUpdate = functions.firestore
    .document('versions/{version_id}/protests/{protest_id}/updates/{update_id}').onWrite((change, context) => {
    if (!change.after.exists) {
    return;
    }
    const newValue = change.after.data();
    const fullName = `${newValue?.first_name} ${newValue?.last_name}`;
    return change.after.ref.set(
    {
    “full_name”: fullName,
    },
    {
    merge: true,
    }
    );
    });