import express from "express";
import dotenv from "dotenv";
const TopHeadlineRouter = express.Router();
dotenv.config();
const API_KEY = process.env.API_KEY;
TopHeadlineRouter.get("/api/topheadline", (req, res) => {
  const uri = `https://newsapi.org/v2/top-headlines?country=in&apiKey=${API_KEY}`;
  fetch(uri)
    .then((response) => response.json())
    .then((data) => {
      res.json(data);
    })
    .catch((err) => {
      res.status(500).json({
        message: "Failed to fetch headlines",
      });
    });
});
export default TopHeadlineRouter;
