const mongoose = require("mongoose");
const validator = require("validator");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const SECRECT_KEY = "abcdefghijklmnop";

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
    validate(value) {
      if (!validator.isEmail(value)) {
        throw new Error("Not Valid Email");
      }
    },
  },
  password: {
    type: String,
    required: true,
    minlength: 6,
  },
  phone_no: {
    type: String,
    required: true,
    // minlength: 10,
    // trim: true,
    // match : /^[+]{1}(?:[0-9\-\(\)\/\.]\s?){6, 15}[0-9]{1}$/
    // match : /^[+]{1}?:[0-9\\-\\(\\)\\/""\\.]\\s?{6, 15}[0-9]{1}$/
  },
  role: {
    type: String,
    enum: ["user", "admin", "employee"], 
    default: "user", 
  },
  tokens: [
    {
      token: {
        type: String,
        required: false,
      },
    },
  ],
  roomNumber: String,
  accessGranted: {
    type: Boolean,
    default: false,
  },
  grantedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "user",
  },
});

// hash password
userSchema.pre("save", async function (next) {
  if (this.isModified("password")) {
    this.password = await bcrypt.hash(this.password, 12);
  }

  next();
});

// token generate
userSchema.methods.generateAuthtoken = async function () {
  try {
    let newtoken = jwt.sign({ _id: this._id }, SECRECT_KEY, {
      expiresIn: "1d",
    });

    this.tokens = this.tokens.concat({ token: newtoken });
    await this.save();
    return newtoken;
  } catch (error) {
    res.status(400).json(error);
  }
};

// creating model
const users = new mongoose.model("users", userSchema);

module.exports = users;
