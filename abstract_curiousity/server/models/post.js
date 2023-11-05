import mongoose from "mongoose";
const postSchema = mongoose.Schema({
  author: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
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
    default: Date.now,
  },
  content: {
    type: String,
  },
  summary: {
    type: String,
  },
});
const Post = mongoose.model("Post", postSchema);
export default Post;
