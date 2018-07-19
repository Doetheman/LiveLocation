// Import Admin SDK
var admin = require("firebase-admin");
// Get data from Firebase
var serviceAccount = require("path/to/serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://livelocation-bc32d.firebaseio.com"
});
