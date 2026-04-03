const db = require("../configs/db");

const accSchema = new db.mongoose.Schema(
  {
    firebaseUid: { type: String, required: true, unique: true },
    fullName: { type: String },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
    },
    provider: {
      type: String,
      enum: ["google.com", "facebook.com", "password"],
      required: true,
    },
    role: {
      type: String,
      enum: ["superAdmin", "admin", "user"],
      default: "user",
    },
    avatarUrl: { type: String, default: null },
    active: { type: Boolean, default: true },
    deletedAt: { type: Date, default: null },
  },
  { collection: "accounts", timestamps: true },
);

let accModel = db.mongoose.model("accModel", accSchema);
module.exports = { accModel };
