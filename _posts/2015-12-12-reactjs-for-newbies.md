---
layout: post
title: "ReactJS for Newbies"
subtitle: "ReactJS for Newbies"
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/react.png
share-img: /assets/img/path.jpg
tags: [ruby, vietnamese]
author: kieetnvt
---


> TL;DR

React is just the UI, lots of developer use it for V in MVC. React binding to View with Virtual DOM, it simplier and better performance. React implements one-way data flow. (Angular is two-way binding!)

# 1. Include react.js and react-dom.js

Including 2 files in your application:

- [react.js](https://github.com/tuankiet/react-tutorial/blob/master/build/react.js)
- [react-dom.js](https://github.com/tuankiet/react-tutorial/blob/master/build/react-dom.js)

Example:

~~~
<!DOCTYPE html>
<html>
<head>
  <title></title>
  <meta charset="UTF-8" />
  <title>Hello React!</title>
  <script src="build/react.js"></script>
  <script src="build/react-dom.js"></script>
</head>
  <body>
    <div id="content"></div>
    <script type="text/babel" src="scripts/controller.js"></script>
    <script type="text/babel">
    </script>
  </body>
</html>
~~~

# 2. Following [facebook tutorial](https://facebook.github.io/react/docs/tutorial.html)

> React mean re-rendering anything to anywhere in DOM

> Can code it easy than Angular

> React is safety

We create the file (controller.js) which contain js code by JSX-syntax and include in our app. First, React compile JSX-syntax to JS-syntax and render compiled components to specific-DOM in HTML file. When components is compiled, its return HTML code as a value for specific-DOM can apply them.

![reactjs overview rendering](/images/react-js-overview.png)

Some keys we must remember when think about React:

1. React virtual DOM
2. Component variable
3. Component properties
4. Set and Update state of variable of component

Another example of basic component, we have basic idea:

1. ReactDOM create `ListProductsHandler` component and render its value into native dom `content`

2. `ListProductsHandler` execute
  - `getInitialState` is a react's function first of all and run one time: it init data state for var `ListProductsHandler`
  - `componentDidMount` is a react's function will automatic after a component is rendered for the first time, it call `loadListProductsFunction` after `intervalLooper` (2s)
  - `loadListProductsFunction` call ajax with api_url to get result from server, if success, it set result to data state
  - finally, it return render `ListProducts` with props data

3. `ListProducts` execute
  - it use props data and do map it into call-back loop function
  - return render div class contain product name and price

4. After all of them execute done, React apply return render into Native Dom with html code.

{% highlight js %}
var Product = React.createClass({
  render: function(){
    return (
      <div className="productClass">
        <div className="productNameClass">{this.props.name}</div>
        <div className="productPriceClass">{this.props.price}</div>
      </div>
    );
  }
});

var ListProducts = React.createClass({
  render: function(){
    var listProducts = this.props.data.map(function(product){
      return (
        <Product name={product.name} price={product.price}></Product>
      );
    });
    return (
      <div className="listProductsClass">
        {listProducts}
      </div>
    );
  }
});

var ListProductsHandler = React.createClass({
  getInitialState: function(){
    return {data: []};
  },
  componentDidMount: function(){
    this.loadListProductsFunction();
    setInterval(this.loadListProductsFunction, this.props.intervalLooper)
  },
  loadListProductsFunction: function(){
    $.ajax({
      url: this.props.api_url,
      dataType: 'json',
      cache: false,
      success: function(data){
        this.setState({data: data});
      }.bind(this),
      error: function(xhr, status, err){
        console.log(this.props.api_url, status, err.toString());
      }.bind(this)
    });
  },
  render: function(){
    return (
      <div className="reactDomRenderMain">
        <h1>List of Products</h1>
        <ListProducts data={this.state.data}></ListProducts>
      </div>
    )
  }
});

ReactDOM.render(
  <ListProductsHandler api_url="/api/products" intervalLooper={2000}></ListProductsHandler>,
  document.getElementById('content')
);
{% endhighlight %}

# 3. React Vs Angular

React is better than angular?

1. With Virtual DOM Component, React can re-rendering many times.

2. Help developer maintaince easy than Angular

3. In Angular, we always to check `$scope` variable, it make confuse for us. We must defind controller, model and apply in view, we must code not only in js file also in html file

4. In Angular, we must use many directive, ng-bind, ng-model, ng-if, ng-...etc... i don't remember all of them. if google don't have angular api docs clearly we can not use be right.

5. React bring for developer the way to code the function, the component and reuse it any where. like OOP and META programming.
