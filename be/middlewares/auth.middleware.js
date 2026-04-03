const admin = require("../configs/firebase.config");
const { accModel } = require("../models/account.model");

const verifyToken = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ msg: "Unauthorized: No token provided" });
    }

    const token = authHeader.split(" ")[1];
    const decodedToken = await admin.auth().verifyIdToken(token);

    const account = await accModel.findOne({ firebaseUid: decodedToken.uid });
    if (!account) return res.status(401).json({ msg: "Account not found" });

    req.user = account;
    next();
  } catch (err) {
    console.error("Token verification error:", err.message);
    return res.status(401).json({ msg: "Invalid token" });
  }
};

module.exports = { verifyToken };
