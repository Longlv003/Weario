var express = require("express");
var router = express.Router();
var accCtrl = require("../controllers/account.controller");

// Acc
router.post("/auth/firebase", accCtrl.verifyFirebaseUser);

module.exports = router;
