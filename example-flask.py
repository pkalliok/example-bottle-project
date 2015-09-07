
from flask import Flask
myapp = Flask('example-flask')

@myapp.route('/')
def default(): myapp.redirect('/greet/World')

@myapp.route('/greet/<thing>')
def greet(thing): return "Hello, %s!" % thing

if __name__ == '__main__': app.run()

