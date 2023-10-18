import express from "express";
import User from "../models/user.js";
import bcrypt from "bcryptjs";
const authRouter = express.Router();
authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, firebaseUid } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({
        message: "User already exists",
      });
    }
    //CREATE USER
    let user = new User({
      firebaseUid,
      name,
      email,
    });
    await user.save();
    console.log(user);
    return res.status(200).json({
      message: "User created successfully",
      user,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      message: err.message,
    });
  }
});

authRouter.put("/api/editProfile", async (req, res) => {
  try {
    const { name, email, bio } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({
        message: "User not found",
      });
    }
    user.name = name;
    user.bio = bio;
    await user.save();
    return res.status(200).json({
      message: "User updated successfully",
      user,
    });
  } catch (e) {
    return res.status(500).json({
      message: "Internal Server Error",
    });
  }
});
authRouter.get("/api/getEditInfo", async (req, res) => {
  try {
    const email = req.query.email;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({
        message: "User not found",
      });
    }
    return res.status(200).json({
      message: "User Info Delivered successfully",
      user,
    });
  } catch (e) {
    console.log(e);
    return res.status(500).json({
      message: "Internal Server Error",
    });
  }
});
export default authRouter;
