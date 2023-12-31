const users = require("../model/login.model");
const userotp = require("../model/userotp.model");
const mailgen = require("mailgen");
const nodemailer = require("nodemailer");
require("dotenv").config();


let transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL,
    pass: process.env.PASSWORD,
  },
});

const mailGenerator = new mailgen({
  theme: "default",
  product: {
    // Your product name
    name: "HostelKube",
    // Link to your website or app
    link: "https://hostelkube.netlify.app/",
    // Optional product logo
    logo: "https://img.freepik.com/free-vector/editable-hotel-logo-vector-business-corporate-identity-hostel_53876-111553.jpg?w=740&t=st=1693473769~exp=1693474369~hmac=add6d6dc14d02bbec0acdc87e71df9b2fc49da302c380c56edeebe3",
  },
});




exports.userregister = async (req, res) => {
  const { name, email, password, phone_no , role } = req.body;

  if (!name || !email || !password || !phone_no || !role) {
    res.status(400).json({ error: "Please Enter All Input Data" });
  }

  try {
    const presuer = await users.findOne({ email: email });

    if (presuer) {
      res.status(400).json({ error: "This User Allready exist" });
    } else {
      const userregister = new users({
        name,
        email,
        password,
        phone_no,
        role
      });

      const storeData = await userregister.save();
      res.status(200).json(storeData);
    }
  } catch (error) {
    console.log(error);
    res.status(400).json({ error: "Invalid Details", error });
  }
};


exports.userLogin= async (req, res) => {
  const { email, password, role } = req.body;

  if (!email || !password || !role) {
    res.status(400).json({ error: "Please Enter Your Email, Password, and Role" });
    return;
  }

  try {
    const user = await users.findOne({ email: email});


    if (!user) {
      res.status(400).json({ error: "Invalid Credentials" });
      return;
    }

    const OTP = Math.floor(100000 + Math.random() * 900000);

    const existEmail = await userotp.findOne({ email: email });

    if (existEmail) {
      existEmail.otp = OTP;
      await existEmail.save();
    } else {
      const saveOtpData = new userotp({
        email,
        otp: OTP,
      });
      await saveOtpData.save();
    }

    const emailTemplate = {
      body: {
        name: user.name,
        intro: `Your OTP for verification is: ${OTP}`,
        outro: "If you didn't request this OTP, please ignore this email.",
      },
    };

    const emailText = mailGenerator.generatePlaintext(emailTemplate);
    const emailHtml = mailGenerator.generate(emailTemplate);

    const mailOptions = {
      from: process.env.EMAIL,
      to: email,
      subject: "OTP Verification",
      text: emailText,
      html: emailHtml,
    };

    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.error(error);
        res.status(400).json({ error: "Email not sent", details: error.message });
      } else {
        console.log("Email sent", info.response);
        res.status(200).json({ message: "Email sent Successfully" });
      }
    });
  } catch (error) {
    console.error(error);
    res.status(400).json({ error: "Invalid Details", error });
  }
};

exports.otpVerification = async (req, res) => {
  const { email, otp } = req.body;

  if (!email || !otp) {
    res.status(400).json({ error: "Please Enter Your Email and OTP" });
    return;
  }

  try {
    const otpverification = await userotp.findOne({ email: email });

    if (otpverification && otpverification.otp === otp) {
      // Check if otpverification exists and otp matches
      const preuser = await users.findOne({ email: email });

      if (!preuser) {
        res.status(400).json({ error: "User not found" });
        return;
      }

      // Token generation logic if needed
      // const token = await preuser.generateAuthtoken();

      res.status(200).json({ message: "OTP Verification Successful" });
    } else {
      console.log("Invalid OTP");
      res.status(400).json({ error: "Invalid OTP" });
    }
  } catch (error) {
    res.status(400).json({ error: "Invalid Details", error });
  }
};

exports.connectedToBackend = (req, res) => {
  res.status(200).send("Connected to Backend");
};
