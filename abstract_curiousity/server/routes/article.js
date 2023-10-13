import express from "express";
import dotenv from "dotenv";
const ArticleRouter = express.Router();
import Article from "../models/article.js";
import Comment from "../models/comments.js";
import GlobalHistory from "../models/globalhistory.js";
//get articles based on sources like techcrunch, bbc news
ArticleRouter.get("/api/getNewsBySource", (req, res) => {
  try {
    const { sources } = req.body;
    const uri = `https://newsapi.org/v2/everything?domains=${sources.join(
      ","
    )}&apiKey=${process.env.API_KEY}`;
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
  } catch (err) {
    res.status(500).json({
      message: "Internal Server Error",
    });
  }
});

ArticleRouter.get("/api/getNewsByCategory", (req, res) => {
  try {
    const { category } = req.body;
    const uri = `https://newsapi.org/v2/top-headlines?category=${category}&apiKey=${process.env.API_KEY}`;
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
  } catch (err) {
    res.status(500).json({
      message: "Internal Server Error",
    });
  }
});

//save news to Article Table
ArticleRouter.post("/api/saveNewsToArticles", async (req, res) => {
  try {
    const {
      source,
      author,
      title,
      description,
      url,
      urlToImage,
      publishedAt,
      content,
      summary,
      category,
    } = req.body;
    const existingArticle = await Article.findOne({ url });
    if (existingArticle) {
      return res.status(400).json({
        message: "Article already exists",
      });
    }
    //CREATE ENTRY IN DB
    const article = new Article({
      source,
      author,
      title,
      description,
      url,
      urlToImage,
      publishedAt,
      content,
      summary,
      category,
    });
    await article.save();
    return res.status(200).json({
      message: "Article saved successfully",
      article,
    });
  } catch (err) {
    res.status(500).json({
      message: err.message,
    });
  }
});
//save article to history
ArticleRouter.post("/api/saveArticleToGlobalHistory", async (req, res) => {
  try {
    const { articleId, userId } = req.body;
    const existingArticle = await GlobalHistory.findOne({
      article: articleId,
      user: userId,
    });
    if (existingArticle) {
      existingArticle.timestamp = Date.now();
      await existingArticle.save();
    } else {
      const globalHistory = new GlobalHistory({
        article: articleId,
        user: userId,
      });
      await globalHistory.save();
      res.status(200).json({
        message: "Article saved to global history successfully",
      });
    }
  } catch (err) {
    res.status(500).json({
      message: "Internal Server Error",
    });
  }
});
ArticleRouter.get("/api/getUserArticlesFromGlobalHistory", async (req, res) => {
  try {
    const { userId } = req.body;
    const globalHistory = await GlobalHistory.find({ user: userId })
      .populate("article")
      .populate("comments");
    return res.status(200).json({
      message: "Articles fetched successfully",
      globalHistory,
    });
  } catch (err) {
    res.status(500).json({
      message: "Internal Server Error",
    });
  }
});
ArticleRouter.post("/api/likearticle", async (req, res) => {
  try {
    const { articleId, userId } = req.body;
    const existingArticle = await GlobalHistory.findOne({
      article: articleId,
      user: userId,
    });
    if (existingArticle) {
      existingArticle.like = !existingArticle.like;
      await existingArticle.save();
      res.status(200).json({
        message: "Article liked successfully",
        existingArticle,
      });
    } else {
      res.status(400).json({
        message: "Article not found in global history",
      });
    }
  } catch (err) {
    res.status(500).json({
      message: "Internal Server Error",
    });
  }
});
ArticleRouter.post("/api/Addcommentarticle", async (req, res) => {
  try {
    const { articleId, userId, comment } = req.body;
    const existingArticle = await GlobalHistory.findOne({
      article: articleId,
      user: userId,
    });
    if (existingArticle) {
      let newcomment = new Comment({
        user: userId,
        article: articleId,
        comment,
      });
      await newcomment.save();
      existingArticle.comments.push(newcomment);
      await existingArticle.save();
      return res.status(200).json({
        message: "Comment added successfully",
      });
    } else {
      res.status(400).json({
        message: "Article not found in global history",
      });
    }
  } catch (err) {
    console.log(err);
    res.status(500).json({
      message: "Internal Server Error",
    });
  }
});
// ArticleRouter.post("/api/removecommentarticle", async (req, res) => {
//   try {
//     const { articleId, userId, comment } = req.body;
//     const existingArticle = await GlobalHistory.findOne({
//       article: articleId,
//       user: userId,
//     });
//     if (existingArticle) {
//       existingArticle.comments = existingArticle.comments.filter(
//         (c) => c !== comment
//       );
//       await existingArticle.save();
//       return res.status(200).json({
//         message: "Comment removed successfully",
//       });
//     } else {
//       res.status(400).json({
//         message: "Article not found in global history",
//       });
//     }
//   } catch (err) {
//     res.status(500).json({
//       message: "Internal Server Error",
//     });
//   }
// });
//get articles from global history

//summarise article
//openAi Api to summarise article
ArticleRouter.post("/api/summarizeArticle", async (req, res) => {
  try {
    const { articleId } = req.body;
    const article = await Article.findById(articleId);
    if (!article) {
      return res.status(400).json({
        message: "Article not found",
      });
    }
    const uri = `https://api.openai.com/v1/engines/davinci-instruct-beta/completions`;
    const body = {
      prompt: article.content,
      max_tokens: 100,
      temperature: 0.7,
      top_p: 1,
      frequency_penalty: 0.5,
      presence_penalty: 0.5,
      stop: ["\n", "testing"],
    };
    const response = await fetch(uri, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
      },
      body: JSON.stringify(body),
    });
    const data = await response.json();
    return res.status(200).json({
      message: "Article summarised successfully",
      summary: data.choices[0].text,
    });
  } catch (err) {
    res.status(500).json({
      message: "Internal Server Error",
    });
  }
});
export default ArticleRouter;
