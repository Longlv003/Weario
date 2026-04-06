const { bannerModel } = require("../models/banner.sale.model");

exports.GetListBanner = async (req, res, next) => {
  let dataRes = { msg: "OK", data: null };

  try {
    const banners = await bannerModel
      .find({ is_delete: null })
      .sort({ createdAt: -1 });

    dataRes.data = banners.map((banner) => ({
      ...banner._doc,
      imageBanner: `${req.protocol}://${req.get("host")}/images/banners/${banner.imageBanner}`,
    }));
  } catch (error) {
    dataRes.msg = error.message;
  }

  return res.json(dataRes);
};
