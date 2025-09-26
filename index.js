const express = require("express");
const axios = require("axios");

const app = express();
const PORT = 3000;

app.get("/", async (req, res) => {
  try {
    const response = await axios.get("http://backend-service:5000/api");
    res.send(`Frontend received: ${JSON.stringify(response.data)}`);
  } catch (error) {
    res.send("Error connecting to backend.");
  }
});

app.listen(PORT, () => console.log(`Frontend running on port ${PORT}`));
