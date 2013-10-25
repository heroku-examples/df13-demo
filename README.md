# Dreamforce 2013 Survey Demo

A node app demonstrating Heroku, CloudConnect, and Force.com

## Development Setup

If you're new to Heroku or Node.js development, you'll need to install a few things first:

1. [Heroku Toolbelt](https://toolbelt.heroku.com), which gives you git, foreman, and the heroku command-line interface.
1. [Node.js](http://nodejs.org/)

Clone the repo and install npm dependencies:

```sh
git clone https://github.com/heroku-examples/df13-demo.git
cd df13-demo
npm install
```

```
heroku git:remote -a df13-demo
heroku plugins:install git://github.com/ddollar/heroku-config.git
heroku config:pull
npm install
foreman start
```

Pop open [localhost:5000](http://localhost:5000).

## Accessing the Database

```
psql $(heroku config:get DATABASE_URL)
```

## License

MIT

## To Do

- rename app
- move to heroku-examples github org
- add test harness