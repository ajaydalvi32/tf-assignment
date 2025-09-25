#!/bin/bash
apt-get update -y
apt-get install -y curl git
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs
mkdir /home/ubuntu/express-app
cat <<EOF > /home/ubuntu/express-app/index.js
const express = require('express');
const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
  res.send('Hello from Express Frontend!');
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(\`Express server running on port \${PORT}\`);
});
EOF
cd /home/ubuntu/express-app
npm init -y
npm install express
nohup node index.js &
