#!/bin/bash
apt-get update -y
apt-get install -y python3 python3-pip git
pip3 install flask
cat <<EOF > /home/ubuntu/app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from Flask Backend!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF
nohup python3 /home/ubuntu/app.py &
