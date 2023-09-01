const express = require("express");
const router = express.Router();
const logincontrollers = require("../controller/auth.controller");


router.post("/register", logincontrollers.userregister);
router.post("/sendotp", logincontrollers.otpVerification);
router.post("/login", logincontrollers.userLogin);
router.get("/", logincontrollers.connectedToBackend);


module.exports = router;



