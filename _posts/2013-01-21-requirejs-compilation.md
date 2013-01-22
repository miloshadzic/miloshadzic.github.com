---
title: Compile a RequireJS Project to a Single File
draft: true
---

Splitting all your code into modules and loading them with RequireJS is a very pleasant experience while you're developing.  At some point though I wanted to deliver a single file with all dependencies included. One reason is that many HTTP requests result in slow loading.

RequireJS comes with an optimiser tool called [r.js](https://github.com/jrburke/r.js/). With it you can minimise and concatenate your code. The documentation is in a few places so I had a bit of trouble getting it to do what I want. IMHO the best source of info after [the basics](http://requirejs.org/docs/optimization.html) is the [example build file with all the options explained](https://github.com/jrburke/r.js/blob/master/build/example.build.js).

I'm going to walk through the config I ended up with with a few comments. My project structure looks something like this(a few folders omitted for brevity):

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

All the code is in app and external dependencies are in app/libs. The build.js file looks like this:

```javascript
// build.js

({
  baseUrl: 'app',
  out: 'build/main.js',
```
Your paths will be relative to the baseUrl so it makes sense to make this the app folder as all the files there. Specifying the out parameter tells r.js that you want everything in one file.

One thing that bugged me a bit is that using appDir, modules and dir parameters makes r.js work as if you want a full build folder of various files.

```javascript
  optimize: 'uglify2',

  name: 'libs/almond',
  include: ['main'],
  wrap: true,
```

[Almond](http://github.com/jburke/almond) is a much simpler AMD loader that makes sense if you're not loading modules dynamically. Usually you would use the name parameter to specify the name of the module you load but we're specifying almond here since the goal is to bundle all of our modules and a loader into one file. The include parameter is an array specifying which other modules to include in the build. We specify the "main" one and r.js finds all other dependencies from that.

Wrap, surprisingly wraps module requires into a closure so we only what we export leaks into the environment. To be honest I don't really need this but if you're bundling a widget or something someone will use with a lot of other stuff It's a good idea.

```javascript
  exclude: ['coffee-script'],
  stubModules: ['cs'],
```

I use CoffeScript for development and compile files in the browser. This is obviously too slow for production so we exclude the compiler module and "stub out" the cs loader plugin. This results in all coffee files being compiled to JavaScript and inlined.

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

The rest of it is standard specifying of paths. It took me a bit to figure out how to do this and I hope it helps someone on the same road.
