const admin = require("firebase-admin");
const serviceAccount = require("./weario-app-firebase-adminsdk-fbsvc-5da1a8cbe6.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

module.exports = admin;
