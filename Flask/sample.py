from flask import Flask

app = Flask(__name__)


@app.route('/')
def hello():
    return '<marquee behavior="alternate"><h1>KELOMPOK 1 SHELL SCRIPT</h1></marquee>'


if __name__ == '__main__':
    app.run(port=1111)
