import mongoose from "mongoose";
const userSchema = mongoose.Schema({
  name: { type: String, required: true, trim: true },
  email: {
    type: String,
    required: true,
    unique: true,
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Please enter a valid email address", //runs when validator is false
    },
  },
  phone: {
    type: String,
    required: true,
    unique: true,
    validate: {
      validator: (value) => {
        const re = /^[0-9]{10}$/;
        return value.match(re);
      },
      message: "Please enter a valid phone number",
    },
  },
  password: {
    required: true,
    type: String,
    validate: {
      validator: (value) => {
        return value.length > 6;
      },
      message: "Password must be greater than 6 characters",
    },
  },
  writer: {
    type: Boolean,
    default: false,
  },
  //liked articles
});
const User = mongoose.model("User", userSchema);
export default User;
