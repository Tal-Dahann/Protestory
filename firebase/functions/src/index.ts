import * as functions from "firebase-functions";
import * as admin from "firebase-admin";


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


// eslint-disable-next-line max-len
// Listens for new messages added to /messages/:documentId/original and creates an
// uppercase version of the message to /messages/:documentId/uppercase
exports.makeUppercase = functions.firestore.document("/messages/{documentId}")
    .onCreate((snap, context) => {
      // Grab the current value of what was written to Firestore.
      const original = snap.data().original;

      // Access the parameter `{documentId}` with `context.params`
      functions.logger.log("Uppercasing", context.params.documentId, original);

      const uppercase = original.toUpperCase();

      // eslint-disable-next-line max-len
      // You must return a Promise when performing asynchronous tasks inside a Functions such as
      // writing to Firestore.
      // Setting an 'uppercase' field in Firestore document returns a Promise.
      return snap.ref.set({uppercase}, {merge: true});
    });


export const notifyNewProtestUpdate = functions.firestore
    // eslint-disable-next-line max-len
    .document("/versions/{version_id}/protests/{protest_id}/updates/{update_id}").onCreate((snap, context) => {
      const data = snap.data();
      const content = data.content as string;


      const message = {
        data: {
          protest_id: context.params.protest_id,
          update_content: content,
        },
        notification: {
          title: "New Update",
          body: content,
        },
        topic: context.params.protest_id,
      };

      admin.messaging().send(message)
          .then((response) => {
            // Response is a message ID string.
            console.log("Successfully sent message:", response);
          })
          .catch((error) => {
            console.log("Error sending message:", error);
          });
    }
    );
