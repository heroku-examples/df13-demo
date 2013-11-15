# Dreamforce 2013 Opinion Demo

A node app demonstrating Heroku, CloudConnect, and Force.com

## Development

If you're new to Heroku or Node.js development, you'll need to
install [Node.js](http://nodejs.org/) and the
[Heroku Toolbelt](https://toolbelt.heroku.com), which gives you git,
foreman, and the heroku command-line interface.

Clone the repo and install npm dependencies:

```sh
git clone https://github.com/heroku-examples/df13-demo.git
cd df13-demo
npm install
heroku git:remote -a df13-demo
foreman start web
```

Pop open [localhost:5000](http://localhost:5000).

## Tests

```sh
npm install
npm test
```

## License

MIT