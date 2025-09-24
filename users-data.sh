#!/bin/bash
set -e
yum update -y
yum install -y python3 git gcc make

# Install Node.js 18
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Flask app
mkdir -p /opt/apps/flask_app
cat > /opt/apps/flask_app/app.py <<'PY'
from flask import Flask, jsonify
app = Flask(__name__)
@app.route("/")
def index():
    return jsonify({"message": "Hello from Flask!"})
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
PY

pip3 install flask gunicorn

cat > /etc/systemd/system/flask.service <<'UNIT'
[Unit]
Description=Flask app
After=network.target
[Service]
ExecStart=/usr/bin/gunicorn -w 1 -b 0.0.0.0:5000 app:app
WorkingDirectory=/opt/apps/flask_app
Restart=always
[Install]
WantedBy=multi-user.target
UNIT

# Express app
mkdir -p /opt/apps/express_app
cat > /opt/apps/express_app/package.json <<'JSON'
{
  "name": "express-app",
  "version": "1.0.0",
  "main": "app.js",
  "dependencies": {
    "express": "^4.18.2"
  }
}
JSON

cat > /opt/apps/express_app/app.js <<'JS'
const express = require('express');
const app = express();
const PORT = 3000;
app.get('/', (req, res) => res.send("Hello from Express!"));
app.listen(PORT, () => console.log(`Express running on ${PORT}`));
JS

cd /opt/apps/express_app && npm install --production

cat > /etc/systemd/system/express.service <<'UNIT'
[Unit]
Description=Express app
After=network.target
[Service]
ExecStart=/usr/bin/node /opt/apps/express_app/app.js
WorkingDirectory=/opt/apps/express_app
Restart=always
[Install]
WantedBy=multi-user.target
UNIT

# Enable services
systemctl daemon-reload
systemctl enable flask.service express.service
systemctl start flask.service express.service
