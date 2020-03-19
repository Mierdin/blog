---
layout: post
title: 'Solving "NAME is not exported by MODULE" When Using Local NPM Dependencies'
author: Matt Oswalt
comments: true
categories: ['Blog']
featured_image: https://oswalt.dev/assets/2020/03/npm-logo.png
date: 2020-03-18T00:00:00-00:00
tags:
  - 'javascript'
---

This blog post will focus on a topic I don't usually dive into (Javascript and related tooling), but I felt like others might benefit from the solution to a problem I encountered while doing local development for `antidote-web`, the web front-end that powers [NRE Labs](https://nrelabs.io/).

A quick aside on the architecture for the front-end code for the Antidote platform - the [`antidote-web`](https://github.com/nre-learning/antidote-web) project is the lynchpin for everything. It's where the general structure of the front-end app is managed. However, we recently engaged a [professional web development shop](https://www.bitovi.com/) to restructure and modernize the application, and as a result of this effort, it now depends on a number of sub-projects in order to function:

- [`antidote-ui-components`](https://github.com/nre-learning/antidote-ui-components) - this is the real "brains"of the app. This uses Haunted, which is a library that uses the same kind of highly asynchronous experience as React hooks, but for WebComponents.
- [`antidote-localizations`](https://github.com/nre-learning/antidote-localizations) - manages the localizations for the front-end code. Allows for easier addition of new languages to the site.
- [`nre-styles`](https://github.com/nre-learning/nre-styles) - contains all of the styling information for the web front-end and other web properties designed to have the same look and feel.

These dependencies are referenced in the project's [`package.json`](https://github.com/nre-learning/antidote-web/blob/master/src/package.json) file:

```json
...
"dependencies": {
  "antidote-localizations": "nre-learning/antidote-localizations",
  "antidote-ui-components": "nre-learning/antidote-ui-components",
  "nre-styles": "nre-learning/nre-styles"
},
...
```

On build, these dependencies are pulled down and packaged up to make one web application at runtime. Generally, this is desired - especially when packaging for a given release - you want to be able to refer to specific Git tags, and things like that.

However, during development, one problem with having these projects broken out is that development becomes difficult. It would be **incredibly** frustrating to have to commit and push a change to the `antidote-ui-components`, and then `cd` over to `antidote-web` to build it, and only then do you get to see what your change did. It's far better to use the local directory as a source, rather than the upstream repository. Fortunately, this is an [easy configuration change](https://docs.npmjs.com/files/package.json#local-paths):


```json
...
"dependencies": {
  "antidote-localizations": "nre-learning/antidote-localizations",
  "antidote-ui-components": "file:/home/mierdin/Code/GO/src/github.com/nre-learning/antidote-ui-components",
  "nre-styles": "nre-learning/nre-styles"
},
...
```

Now, when I run the `build` for this project, instead of pulling from the Github repository, it will just use my local directory - no need to commit or push anything.

At this point, I ran into a problem that I hadn't seen before:

```bash
~$ npm run build

> antidote-web@1.0.0 build /home/mierdin/Code/GO/src/github.com/nre-learning/antidote-web/src
> npx rollup -c


js/antidote.js → js/bundles/antidote.js...
[!] Error: 'Terminal' is not exported by ../../antidote-ui-components/node_modules/xterm/lib/xterm.js, imported by ../../antidote-ui-components/helpers/use-ssh.js
https://rollupjs.org/guide/en/#error-name-is-not-exported-by-module
../../antidote-ui-components/helpers/use-ssh.js (9:9)
 7: import { useEffect, useReducer, useRef } from 'haunted';
 8: import { FitAddon } from "xterm-addon-fit";
 9: import { Terminal } from "xterm";
             ^
```

As you can see, the output above helpfully [links to an article](https://rollupjs.org/guide/en/#error-name-is-not-exported-by-module) that speaks to the issue a little more. It seems to be an incompatibility with a tool called Rollup (used for packaging our Javascript modules into a single application) and the `xterm` library, which is what the project uses to provide an interactive terminal to the user for learning purposes.

Those instructions recommend using the `namedExports` option to resolve this - effectively providing an explicit mapping between the two pieces of information that Rollup cannot determine itself.

Upon looking at the [rollup configuration](https://github.com/nre-learning/antidote-web/blob/master/src/rollup.config.js) for the project, I noticed that the previous developer had already added an option to account for this:

```javascript
...
commonjs({
    namedExports: {
        // needed for xterm compatibility w/ rollup
        'xterm': [ 'Terminal' ]
    },
}),
...
```

So at this point, two things are strange to me. First, why is this still an issue if the previous developer already accounted for it and added the appropriate configuration for it? Second, why is this only happening now, after I changed to use this dependency from the local filesystem as opposed to the upstream repository?

I concluded that the namedExports configuration is somehow affected by our use of relative paths in the `package.json` dependencies. After a bit of hunting around (and an in-no-way-unhealthy amount of trial and error) I determined this to be true, and the fix to be a matter of changing the export key to be a relative path as well - this time to the specific file where this module is declared:

```javascript
...
commonjs({
    namedExports: {
        '../../antidote-ui-components/node_modules/xterm/lib/xterm.js': [ 'Terminal' ]
    },
}),
...
```

So in short, if you wish to develop locally like I do, be wary of dependencies that have this Rollup incompatibility - even if you've previously accounted for it in your Rollup configuration, you may still have to adjust it.
