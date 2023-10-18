import mongoose from "mongoose";
const articleSchema = mongoose.Schema({
  source: {
    id: String, // ID of the news source (can be null)
    name: String, // Name of the news source
  },
  author: {
    type: String,
  },
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
  },
  url: {
    type: String,
    required: true,
  },
  urlToImage: {
    type: String,
  },
  publishedAt: {
    type: Date,
    required: true,
  },
  content: {
    type: String,
  },
  category: {
    type: String,
    enum: ["sports", "politics", "entertainment", "technology", "business"],
  },
  summary: {
    type: String,
  },
});
const Article = mongoose.model("Article", articleSchema);
export default Article;
