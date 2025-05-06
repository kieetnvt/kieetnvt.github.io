---
layout: post
title: "Why Choose Vite over Create React App (CRA)"
subtitle: React development has usually started with Create React App (CRA), but nowadays Vite is better in many aspects, as this article shows.
cover-img: /assets/img/vite.png
thumbnail-img: /assets/img/vite.png
share-img: /assets/img/vite.png
tags: [vite react]
author: kieetnvt
---

### Overview of CRA

CRA is a popular tool built upon Babel and Webpack to help developers quickly set up a React project. The React team has officially announced its support for the tool, making it a popular and reliable choice.

This React tool comes with a preconfigured environment that takes care of most of the configuration, which would otherwise be burdened on the developers’ shoulders. This helps React developers focus on writing code rather than worrying about the configuration files. In addition, CRA can create scripts and dependencies.

Some prominent features that distinguish it from other tools include production building, hot module replacement, and a local development server. However, as the app grows, its performance and speed deteriorate.

### Benefits of CRA

Some of the unique benefits of using CRA for your React projects include:

- Official Support - The React team is maintaining this tool. Getting support from the official team is a huge advantage for all those developers employing React in their projects. This also means that the official React team will bear the responsibility of fixing bugs and adding new advanced features to CRA tool. They are also expected to release regular updates.

- Mature Ecosystem - CRA is not a new tool in the community. It’s a mature tool with the support of a large and vibrant community. Numerous third-party plugins are available for it. This allows you to use this tool with various development frameworks, IDEs, and libraries. You can refer to online tutorials and detailed documentation for guidance or when you come across any problem. In short, the tool boasts an extensive ecosystem.

- Automatic Configuration - When writing React code with a CRA, you no longer have to worry about building configurations. The tool does all the heavy lifting by handling configurations and helping developers reduce development time. Not getting involved in mundane and repetitive tasks significantly benefits developers, especially beginners.

- Opinionated Defaults—With CRA, you follow best practices and utilize sensible defaults, helping you lay a solid foundation for your React project. Opinionated defaults also give a headstart in the development process, saving valuable time and increasing productivity along the way.

### How does CRA work?

CRA works in a well-organized manner, as mentioned below:

- Webpack forms a tree of dependencies from your project’s modules, leveraging the index.js file and the application’s entry point.
- Next, the Babel transpiles your code.
- After that, CRA bundles the code and serves it through the Express web server.
- In the end, CRA sets up sockets to manage hot module replacement.

This is a quick approach to software development with an intense focus on coding. But despite all its benefits, it has a noteworthy flaw. Whenever you implement changes in the React code, the Webpack repeats the bundling process every single time, no matter if it’s a single or tiny change.

This will slow down your React application as its source code grows more extensive, increasing the time it takes to run a dev server and create a new project.

### Overview of Vite

Vite is a modern build tool built upon Rollup bundler. It was designed specifically to address the limitations of existing build tools and is optimized for speed and performance.

Vite leverages a native development server, native browser imports, and native ECMAScript Modules to ensure seamless app development, resulting in faster build times. Its development server can send multiple responses for a single client request using HTTP/2 server push.

Vite also provides features like hot reloading and code splitting. This build tool can be used to develop applications that don’t need complex configurations.

### Benefits of Vite

Let us discuss a few benefits of using Vite for React app development.

- Extensive ecosystem - Vite is quite an extensible and flexible option. It allows you to integrate with a large array of tools to extend its capabilities. Its rich plugin ecosystem supports multiple development frameworks, including React and Svelte.
- Rapid development - Vite leverages the native ECMAScript Modules imports to eliminate the manual bundling process during development. It provides pre-bundled modules and dependencies, leading to reduced development time. On top of that, its lightning-fast development server minimizes the build time.
- Optimized code sizes - Features like tree-shaking and lazy loading of modules help developers reduce the size of the code and optimize it for performance. These features from Vite can come in handy when working on projects with many modules. Reduced code sizes also help speed up the development process, leading to enhanced developer productivity.
- Flexible configurations - In terms of configuration, Vite is very flexible. It enables you to tailor-cut every single aspect of the React project setup to meet your unique requirements. With such a flexible configuration system, you can use Vite for a broad spectrum of projects.

### How does Vite Work?

Vite primarily does two things during development: it serves the code locally, and for production purposes, it bundles your CSS and JavaScript along with other assets.

Several tools available in the market, including Rollup, Parcel, and Webpack, do the same thing. So, what makes Vite unique?

The problem with those old frameworks is that they rebuild everything on each save, change, and update. Now, if you manage a large app, even for a small save, you must wait several minutes despite using hot reloading with those frameworks.

In short, their update speed will get slower as you add more code and dependencies to your React application. Meanwhile, Vite takes the opposite approach by starting with the server, taking unchanged dependencies, and using esbuild to bundle them together.

![Bundle Based Dev Server](/assets/img/bundle-based-dev-server.jpg)

The above image displays the traditional development server based on bundles. It shows an entry point, all possible routes, and modules that are bundled together to prepare the development server.

But with Vite, you don’t need to pre-bundle everything. It uses route-based code splitting to check which piece of code or module needs to be loaded.

![Native ESM Based Dev Server](/assets/img/native-esm-dev-server.jpg)

In modern browsers, Vite uses native ECMAScript Modules to serve the source code. Here, the browser is tasked with bundling the code during development. As a result, your code can be loaded instantly, regardless of your app size.

Additionally, Vite supports hot module replacement to establish a fast feedback loop in development. During production, Vite also leverages Rollup to manage configurations.

### Difference between Vite and CRA

#### Performance

While pre-bundling, Vite uses ECMAScript Modules to convert dependencies with various internal modules into a single module. When kept separated, these modules can send hundreds of requests at the same time, congesting the browser and slowing the load time.

However, after pre-bundling them into a single module, it can only send one request, increasing the app’s performance. Meanwhile, CRA lacks pre-bundling, and without that, hundreds of requests fire up at the same time, resulting in a congested browser and deteriorated app performance.

#### Development Speed

Vite is faster than CRA, whether it’s development server startup time or build time, because it uses an ECMAScript Modules-based development server, while CRA has a Webpack-based development server.

Moreover, Vite leverages a preconfigured Rollup for building and releasing apps into a production environment. Compared to Webpack, Rollup handles bundling with excellent efficiency. Hence, the build time of Vite is faster with a smaller-sized output.

#### Configuration

One of the primary reasons React developers prefer to use CRA is its zero-configuration setup. It can run a React app using a single command. However, this compromises CRA’s flexibility, and that’s why you need to extend its capabilities when working with large projects.

Meanwhile, Vite allows you to add new capabilities to this build tool by quickly writing Rollup plugins. Rollup has an extensive plugin ecosystem that can be leveraged to create an environment suited to your project requirements.

#### Why Choose Vite?

Vite offers numerous advantages over CRA. Let’s find out some major benefits.

##### Efficient and high-performance builds

Vite helps you create optimized production builds using preconfigured commands such as tree shaking, async chunk loading, and CSS code splitting. This helps you maintain smaller bundle sizes and improve build performance.

Vite’s development server imports ECMAScript Modules, eliminating the need for bundling. As a result, your development speed increases.

##### Faster file updates

As the codebase grows larger over time, the file updates slow down in CRA. However, things work differently in Vite. It prefers performing hot module replacement over native ECMAScript Modules.

When you edit a module of a file, Vite annuls its chain with its closest hot module replacement boundary. This simplifies the hot module replacement updates and increases its speed, regardless of the app size. Vite uses HTTP requests to fetch the modules and HTTP headers to cache, leading to increased full-page reload speed.

Moreover, Vite leverages the 304 Not Modified to make source code module requests conditional and Cache-Control: max-age=31536000,immutable for caching the dependency module requests.

##### Rich features

Vite offers built-in support for dynamic imports. For example, it can import various file types, such as TypeScript (ts), TypeScript with JSX (tsx), JavaScript with JSX (jsx), and CSS files. This helps ensure that updates are quickly reflected in the browser.

##### Quick startup for development server

CRA builds an entire application altogether before delivering it to the user. Vite divides the modules of React apps into two categories:

Dependencies: They are plain JavaScript that does not change during development. Vite uses esbuild to pre-bundle them to ensure that every dependency gets to send only a single HTTP request. Because they don’t change, dependencies are easy to cache. After that, you can skip pre-bundling.
Source code: They are the non-plain JavaScript that changes over time. They need to be edited, changed, and updated as per requirements. Vite uses native ECMAScript Modules to serve the source code. It helps improve the start time of the dev server.

### Migrating from CRA to Vite

Uninstall react-scripts. When preparing for migration, the first step is to remove CRA from your project by uninstalling react-scripts.

~~~
npm uninstall react-scripts
~~~

Install Vite and its related dependencies.

~~~
npm install vite @vitejs/plugin-react --save-dev
~~~

Update package.json to add Vite scripts.

~~~
"scripts": {
  "dev": "vite",
  "build": "vite build",
  "serve": "vite preview",
}
~~~

Move the index.html file to the project’s root directory. Move your public/index.html file to the root directory of your project and change the script tag accordingly.

~~~
<!-- index.html -->
<body>
  <noscript>You need to enable JavaScript to run this app.</noscript>
  <div id="root"></div>

  <script type="module" src="/src/index.jsx"></script>
</body>
~~~

Change file extensions .js/.jsx. Change the file extensions of app.js and index.js to app.jsx and index.jsx, respectively. Additionally, if any file contains JSX code, all related files must have the .jsx extension.

Add the vite.config.js file to the project’s root directory. To set up Vite for your project, make sure to add the vite.config.js file to the root of your project. You can add your preferences to this file. For reference, check out Vite Doc.

~~~
// vite.config.js
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
});
~~~

Change the .env file to use env variables. If you have a .env file, always prefix the environment variable name with VITE_ to avoid inadvertently exposing environment variables to the client.

~~~
VITE_SOME_KEY=123
~~~

VITE_SOME_KEY will be used as import.meta.env.VITE_SOME_KEY to your client source code.

~~~
console.log(import.meta.env.VITE_SOME_KEY); // "123"
~~~

Run the project. Once you’ve finished the steps above, you’re all set to launch your new Vite-powered React app. Now run.

~~~
npm run dev
~~~

### Conclusion

This article provides a decent comparison between CRA and Vite, with reasons and a process for migrating your React project from one tool to the other. However, one can argue from either side.

CRA is a great tool for starting a new React project on a whim, whereas Vite has proven its worth in handling large React projects with greater efficiency. Both of these build tools are reliable solutions with their own set of strengths and weaknesses.

The burden of decision falls upon you. No matter how great a tool is, it’s worth nothing if it can’t help you fulfill your requirements. So, carefully weigh your options against your project requirements to choose a suitable tool.
