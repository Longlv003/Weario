const db = require("../configs/db");

const bannerSchema = new db.mongoose.Schema(
  {
    bannerCode: { type: String, required: true, unique: true },
    bannerName: { type: String, required: true },
    imageBanner: { type: String, required: true },
    deleteAt: { type: Date, default: null },
  },
  { collection: "banner_sales", timestamps: true },
);

let bannerModel = db.mongoose.model("bannerModel", bannerSchema);
module.exports = { bannerModel };
