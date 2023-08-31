const express = require("express");
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
const cors = require("cors");
const loginRoute = require("./routes/login.route");
// const router = require("./routes/login.route");

const app = express();
const PORT = process.env.PORT || 3000;
const DB_URI =
  "mongodb://admin:admin@ac-9tonkeq-shard-00-00.wwmzhow.mongodb.net:27017,ac-9tonkeq-shard-00-01.wwmzhow.mongodb.net:27017,ac-9tonkeq-shard-00-02.wwmzhow.mongodb.net:27017/user?ssl=true&replicaSet=atlas-xsr3qk-shard-0&authSource=admin&retryWrites=true&w=majority";

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(express.json());

// Connect to MongoDB
mongoose
  .connect(DB_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => {
    console.log("Connected to MongoDB");

    
  })

  .catch((error) => {
    console.error("MongoDB connection error:", error);
  });

// Routes
app.use("/user", loginRoute);

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});