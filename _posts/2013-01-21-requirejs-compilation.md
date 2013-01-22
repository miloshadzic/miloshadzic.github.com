---
title: Compile a RequireJS Project to a Single File
draft: true
---

Splitting all your code into modules and loading them with RequireJS makes for a very pleasant development experience.  At some point though, I'd like to deliver a single file with all the dependencies included. The biggest reason being that HTTP requests are expensive and by lazy-loading all your tiny modules, RequireJS makes a lot of them.

RequireJS comes with an optimizing tool called [r.js](https://github.com/jrburke/r.js/). You can use it to minimize and concatenate your code. The documentation is in a few places and I had a bit of trouble getting it to do what I want. IMHO the best source of info after [the basics](http://requirejs.org/docs/optimization.html) is the [example build file with all the options explained](https://github.com/jrburke/r.js/blob/master/build/example.build.js). I suggest checking out the documentation for installation instructions.

In this tutorial-post I'm going to walk you through the config I ended up with with a few comments. My project structure looks something like this with a few folders omitted for brevity:

```
├── README.md
├── app
│   ├── libs
│   ├── main.js
│   ├── models
│   ├── require.js
│   ├── templates
│   └── views
├── build.js
└── package.json
```

All the code is in app and external dependencies are in app/libs. The build.js file looks like [this](https://gist.github.com/4597201).

```javascript
({
  baseUrl: 'app',
  out: 'build/main.js',
```
Your paths will be relative to the [baseUrl](https://github.com/jrburke/r.js/blob/master/build/example.build.js#L25) so it makes sense to make this the app folder as all the files there. Specifying the [out](https://github.com/jrburke/r.js/blob/master/build/example.build.js#L404) parameter tells r.js that you want everything in one file. The alternative is specifying [dir](https://github.com/jrburke/r.js/blob/master/build/example.build.js#L56) in which case the contents of your app folder are copied into that dir.

A few options like [appDir](https://github.com/jrburke/r.js/blob/master/build/example.build.js#L19), [dir](https://github.com/jrburke/r.js/blob/master/build/example.build.js#L56) and [modules](https://github.com/jrburke/r.js/blob/master/build/example.build.js#L325) are incompatible with [out](https://github.com/jrburke/r.js/blob/master/build/example.build.js#L404) aka compiling to a single file so don't use those.

```javascript
  optimize: 'uglify2',

  name: 'libs/almond',
  include: ['main'],
  wrap: true,
```

[Almond](http://github.com/jrburke/almond) is a much simpler AMD loader that makes sense in our case since we're not loading modules dynamically.

Usually you would use the [name](https://github.com/jrburke/r.js/blob/master/build/example.build.js#L401) parameter to specify the name of the module you load but we're specifying almond here since the goal is to bundle all of our modules and a loader into one file. The [include](https://github.com/jrburke/r.js/blob/master/build/example.build.js#L402) parameter is an array specifying which other modules to include in the build. We specify the "main" one and r.js finds all other dependencies from that.

[Wrap](https://github.com/jrburke/r.js/blob/master/build/example.build.js#L425), unsurprisingly wraps module requires into a closure so that only what you export gets into the global environment. To be honest, I don't really need this but if you're bundling a widget or something someone will use with a lot of other stuff I guess it's a good idea.

```javascript
  exclude: ['coffee-script'],
  stubModules: ['cs'],
```

I use CoffeScript for development and compile files in the browser. This is obviously too slow for production so we exclude the compiler module and ["stub out"](https://github.com/jrburke/r.js/blob/master/build/example.build.js#L300) the cs loader plugin. This results in all coffee files being compiled to JavaScript and inlined.

```javascript
  paths: {
    backbone: 'libs/backbone-amd',
    underscore: 'libs/underscore-amd',
    jquery: 'libs/jquery',
    cs: 'libs/cs',
    'coffee-script': 'libs/coffee-script',
    text: 'libs/text'
  }
})
```

The rest of it is standard specifying of [paths](https://github.com/jrburke/r.js/blob/master/build/example.build.js#L44).
