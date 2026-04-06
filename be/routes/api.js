var express = require("express");
var router = express.Router();
var accCtrl = require("../controllers/account.controller");
var bannerCtrl = require("../controllers/banner.controller");
var categoryCtrl = require("../controllers/category.controller");
var { categoryValidator } = require("../validators/create.category");
var proCtrl = require("../controllers/product.controller");

// Acc
router.post("/auth/firebase", accCtrl.verifyFirebaseUser);

// Banner
router.get("/banner/sale/get-list", bannerCtrl.GetListBanner);

// Category
router.get("/category/get-list", categoryCtrl.GetListCategory);
router.get("/category/get-list-in-stock", categoryCtrl.GetListCategoryInStock);

// Product
router.get("/product/get-list-in-stock", proCtrl.GetListProductInStock);
router.get("/product/get-list", proCtrl.GetListProduct);

module.exports = router;
