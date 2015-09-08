
# Software project automation example

This is a software project that demonstrates techniques to automate
various aspects of software development:

- build automation (although the build stage is almost nonexistent with
  Python)
- automated deployment
- automated testing of code
- automated testing of dependency isolation
- quality control and code statistics automation
- integration between version control and issue tracking
- integration between issue tracking and code reviews

Almost all automation is implemented with GNU make
(https://www.gnu.org/software/make/) to make it language and
distribution agnostic.  The dependency isolation part of testing is
implemented with Docker (https://www.docker.com/) to make it language
agnostic and also catch dependencies to system tools and commands.

The example software itself is a really simple web service that uses the
Flask framework (http://flask.pocoo.org/) and is written in Python.

