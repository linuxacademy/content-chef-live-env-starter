from flask import Flask, request

app = Flask(__name__)

@app.route("/report", methods=['POST'])
def report():
    if not request.json:
        abort(400)
    app.logger.info("error submitted: %s", request.json)
    return '{"message": "error received"}'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
