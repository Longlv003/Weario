const admin = require("../configs/firebase.config");
const { accModel } = require("../models/account.model");

exports.verifyFirebaseUser = async (req, res) => {
  let dataRes = { msg: "OK", data: null };

  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      dataRes.msg = "Unauthorized: No token provided";
      return res.status(401).json({ dataRes });
    }

    const token = authHeader.split(" ")[1];
    const decodedToken = await admin.auth().verifyIdToken(token);

    const { uid, email, name, picture } = decodedToken;
    const provider = decodedToken.firebase?.sign_in_provider;

    // const rawProvider = decodedToken.firebase?.sign_in_provider || "email";
    // const providerMap = {
    //   google.com: "google",
    //   facebook.com: "facebook",
    //   password: "email",
    // };
    // const provider = providerMap[rawProvider] || "email";

    let user = await accModel.findOne({ firebaseUid: uid });

    if (!user) {
      user = new accModel({
        firebaseUid: uid,
        email,
        fullName: name || null,
        avatarUrl: picture || null,
        provider,
      });
      await user.save();
    }

    dataRes.msg = "Verify success";
    dataRes.data = user;
  } catch (err) {
    console.error("Login/Register error:", err.message);
    dataRes.msg = "Invalid Firebase token";
  }

  return res.json(dataRes);
};
