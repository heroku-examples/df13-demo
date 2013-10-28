# Dreamforce 2013 Survey Demo

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
heroku plugins:install git://github.com/ddollar/heroku-config.git
heroku config:pull
foreman start
```

Pop open [localhost:5000](http://localhost:5000).

## Tests

```
npm install
npm test
```

## Conveniences

```
# remote psql console
psql $(heroku config:get DATABASE_URL)

# sync local pg with remote
./bin/db_pull
```

## License

MIT