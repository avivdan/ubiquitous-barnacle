from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, DevOps!</p>"

@app.route("/echo")
def echo():
    if request.is_json:
        return jsonify(request.json), 200
    return jsonify({"error": "Request must be JSON"}), 400

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
