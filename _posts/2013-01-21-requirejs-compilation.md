---
title: Compile a RequireJS Project to a Single File
layout: post
date: 2013-1-23
draft: false
---

Splitting all your code into modules and loading them with RequireJS
makes for a warm and fuzzy development experience. At some point
though, I'd like to deliver a single file with all the dependencies
included. The biggest reason being that HTTP requests are expensive
and by lazy-loading all your tiny modules, RequireJS makes a lot of
them.

There's an optimizing tool for RequireJS called [r.js][rjs]. You can
use it to minimize and concatenate your code. The documentation is in
a few places and I had a bit of trouble getting it to do what I want.
IMHO the best source of info after [the basic stuff][optimization] is
the [example build file with all the options explained][example]. For
installation instructions just check out the [documentation][rjs].

In this tutorial I'm going to walk you through my build file with a
few added comments. Except for a few dirs omitted for brevity, my
project structure looks like this:

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

All the code is in app and external dependencies are in app/libs. The
build.js file looks like [this](https://gist.github.com/4597201).

```javascript
({
  baseUrl: 'app',
  out: 'build/main.js',
```

Your paths will be relative to the [baseUrl][baseurl] so it makes
sense to make this the app folder as all the files there. Specifying
the [out](out) parameter tells r.js that you want everything in one
file. The alternative is specifying [dir][dir] in which case the
contents of your app folder are copied into that dir.

A few options like [appDir][appdir], [dir][dir] and [modules][modules]
are incompatible with [out][out] aka compiling to a single file so
don't use those.

```javascript
  name: 'libs/almond',
  include: ['main'],
  wrap: true,
```

Usually you would use the [name][name] parameter to specify the name
of the module you load but we're specifying the almond loader here
since the goal is to bundle all of our modules and a loader into one
file. [Almond](http://github.com/jrburke/almond) is a much smaller and
simpler AMD loader that makes sense in our case since we're not
loading modules dynamically.

The [include][include] parameter is an array specifying which other
modules to include in the build. We specify the "main" one and r.js
finds all other dependencies from that.

[Wrap][wrap], unsurprisingly wraps module requires into a closure so
that only what you export gets into the global environment. To be
honest, I don't really need this but if you're bundling a widget or
something someone will use with a lot of other stuff I guess it's a
good idea.

```javascript
  exclude: ['coffee-script'],
  stubModules: ['cs'],
```

I use CoffeScript for development and compile files in the browser.
This is obviously slower than it needs to be for production so we
exclude the compiler module and ["stub out"][stub] the cs loader
plugin. This results in all coffee files being compiled to JavaScript
and inlined.

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

The rest of the file is a standard [paths][paths] configuration.

Finally to compile, run:

```
r.js -o build.js
```

And your compiled project should be in build/main.js.

[stub]: https://github.com/jrburke/r.js/blob/master/build/example.build.js#L300
[paths]: https://github.com/jrburke/r.js/blob/master/build/example.build.js#L44
[wrap]: https://github.com/jrburke/r.js/blob/master/build/example.build.js#L425
[include]: https://github.com/jrburke/r.js/blob/master/build/example.build.js#L402
[name]: https://github.com/jrburke/r.js/blob/master/build/example.build.js#L401
[appdir]: https://github.com/jrburke/r.js/blob/master/build/example.build.js#L19
[dir]: https://github.com/jrburke/r.js/blob/master/build/example.build.js#L56
[modules]: https://github.com/jrburke/r.js/blob/master/build/example.build.js#L325
[out]: https://github.com/jrburke/r.js/blob/master/build/example.build.js#L404
[baseurl]: https://github.com/jrburke/r.js/blob/master/build/example.build.js#L25
[optimization]: http://requirejs.org/docs/optimization.html
[example]: https://github.com/jrburke/r.js/blob/master/build/example.build.js
[rjs]: https://github.com/jrburke/r.js/
