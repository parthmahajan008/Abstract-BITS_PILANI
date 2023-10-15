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
  firebaseUid: {
    type: String,
    required: true,
    unique: true,
  },
  writer: {
    type: Boolean,
    default: false,
  },
  bio: {
    type: String,
    default: "",
  },
  //liked articles
});
const User = mongoose.model("User", userSchema);
export default User;
