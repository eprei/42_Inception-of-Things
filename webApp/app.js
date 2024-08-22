const express = require('express');
const app = express();
const port = 8080;

const message = process.env.MESSAGE || 'Hello, World!';

app.get('/', (req, res) => {
  res.send(`<h1>${message}</h1>`);
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});