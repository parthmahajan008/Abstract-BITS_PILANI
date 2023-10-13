import express from "express";
import dotenv from "dotenv";
import mongoose from "mongoose";
import authRouter from "./routes/auth.js";
import TopHeadlineRouter from "./routes/topheadline.js";
import articleRouter from "./routes/article.js";
//IMPORT FROM OTHER FILES
//INIT
dotenv.config();
const app = express();
const PORT = 3000;
const DATABASE_URL = process.env.DATABASE_URL;
// MIDDLEWARE
app.use(express.json());
app.use(authRouter);
app.use(TopHeadlineRouter);
app.use(articleRouter);
//CONNECTION to DB
mongoose
  .connect(DATABASE_URL)
  .then(() => {
    console.log("Connected to DB");
  })
  .catch((err) => {
    console.log(err);
  });
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}.`);
});
