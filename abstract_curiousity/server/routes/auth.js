import express from "express";
import User from "../models/user.js";
import bcrypt from "bcryptjs";
const authRouter = express.Router();
authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, phone, password } = req.body;

    const existingUser = await User.findOne({ $or: [{ email }, { phone }] });
    if (existingUser) {
      return res.status(400).json({
        message: "User already exists",
      });
    }
    const hashedPassword = await bcrypt.hash(password, 12);
    //CREATE USER
    let user = new User({
      name,
      email,
      phone,
      password: hashedPassword,
    });
    await user.save();
    res.status(200).json({
      message: "User created successfully",
      user,
    });
  } catch (err) {
    console.log(err);
    res.status(500).json({
      message: "Internal Server Error",
    });
  }
});
authRouter.post("/api/login", async (req, res) => {
  try {
    const { email, phone, password } = req.body;
    const user = User.findOne({ $or: [{ email }, { phone }] });
    if (!user) {
      res.status(400).json({
        message: "User does not exist",
      });
    }
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      res.status(400).json({
        message: "Invalid credentials",
      });
    }
    const token = jwt.sign({ id: user._id }, "passwordKey");
    res.json({
      token,
      ...user._doc,
    });
  } catch (err) {
    res.status(500).json({
      message: "Internal Server Error",
    });
  }
});

export default authRouter;
