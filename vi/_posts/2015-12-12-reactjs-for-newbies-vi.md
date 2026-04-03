---
layout: post
title: ReactJS cho Người Mới Bắt Đầu
subtitle: ReactJS cho Người Mới Bắt Đầu
cover-img: "/assets/img/path.jpg"
thumbnail-img: "/assets/img/react.png"
share-img: "/assets/img/path.jpg"
tags:
- ruby
- vietnamese
author: kieetnvt
lang: vi
ref: reactjs-for-newbies
---

> TL;DR

React chỉ là UI, nhiều developer sử dụng nó cho V trong MVC. React binding với View thông qua Virtual DOM, đơn giản hơn và hiệu suất tốt hơn. React triển khai luồng dữ liệu một chiều. (Angular là two-way binding!)

# 1. Include react.js và react-dom.js

Bao gồm 2 file trong ứng dụng của bạn:

- [react.js](https://github.com/tuankiet/react-tutorial/blob/master/build/react.js)
- [react-dom.js](https://github.com/tuankiet/react-tutorial/blob/master/build/react-dom.js)

Ví dụ:

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

# 2. Theo [facebook tutorial](https://facebook.github.io/react/docs/tutorial.html)

> React có nghĩa là re-rendering bất cứ thứ gì đến bất kỳ đâu trong DOM

> Có thể code dễ dàng hơn Angular

> React an toàn

Chúng ta tạo file (controller.js) chứa js code bằng JSX-syntax và include trong app. Đầu tiên, React compile JSX-syntax sang JS-syntax và render các compiled components vào specific-DOM trong HTML file. Khi components được compiled, nó trả về HTML code như một giá trị cho specific-DOM có thể apply chúng.

![reactjs overview rendering](/images/react-js-overview.png)

Một số điểm chính chúng ta phải nhớ khi nghĩ về React:

1. React virtual DOM
2. Component variable
3. Component properties
4. Set và Update state của variable của component

Một ví dụ khác về basic component, chúng ta có ý tưởng cơ bản:

1. ReactDOM tạo component `ListProductsHandler` và render giá trị của nó vào native dom `content`

2. `ListProductsHandler` thực thi
  - `getInitialState` là function đầu tiên của react và chạy một lần: nó khởi tạo data state cho var `ListProductsHandler`
  - `componentDidMount` là function của react sẽ tự động sau khi component được rendered lần đầu tiên, nó gọi `loadListProductsFunction` sau `intervalLooper` (2s)
  - `loadListProductsFunction` gọi ajax với api_url để lấy kết quả từ server, nếu thành công, nó set kết quả vào data state
  - cuối cùng, nó return render `ListProducts` với props data

3. `ListProducts` thực thi
  - nó sử dụng props data và map nó vào call-back loop function
  - return render div class chứa product name và price

4. Sau khi tất cả chúng thực thi xong, React apply return render vào Native Dom với html code.

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

React tốt hơn Angular?

1. Với Virtual DOM Component, React có thể re-rendering nhiều lần.

2. Giúp developer maintain dễ dàng hơn Angular

3. Trong Angular, chúng ta luôn phải check biến `$scope`, nó làm chúng ta bối rối. Chúng ta phải define controller, model và apply trong view, chúng ta phải code không chỉ trong js file mà còn trong html file

4. Trong Angular, chúng ta phải sử dụng nhiều directive, ng-bind, ng-model, ng-if, ng-...etc... tôi không nhớ hết chúng. nếu google không có angular api docs rõ ràng chúng ta không thể sử dụng đúng.

5. React mang đến cho developer cách để code function, component và tái sử dụng nó ở bất kỳ đâu. giống như OOP và META programming.
