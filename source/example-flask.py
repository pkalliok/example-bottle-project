
from flask import Flask, redirect
myapp = Flask('example-flask')

@myapp.route('/')
def default(): return redirect('/greet/World')

@myapp.route('/greet/<thing>')
def greet(thing): return "Hello, %s!" % thing

if __name__ == '__main__': myapp.run(host='0.0.0.0', port=5000)

