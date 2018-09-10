---
id: 611
title: React-ions
date: 2015-02-27T20:39:12+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=611
permalink: /react-ions/
dsq_thread_id:
  - 3552794272
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464982417
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
tags:
  - angular
  - DOM
  - HTML
  - Javascript
  - MVC
  - MVVM
  - react
---
I’ve been working with [Angular](https://angularjs.org/) a lot lately and I’ve been wrapped up in learning everything that comes with it, and it’s got me thinking whether full-fledged JavaScript frameworks are all they’re cracked up to be. Don’t get me wrong, I enjoy working with Angular and a lot of how it works and its design makes sense once you ignore the official tutorials and learn the [best practices](https://github.com/johnpapa/angularjs-styleguide). But it feels like it has a lot of heft behind it, and sometimes the flow of data and UI interaction can get quite confusing once you have a large application.

I’d been seeing lots of mentions of [React](http://facebook.github.io/react/index.html) lately and it intrigued me enough to take a look. What I found were a lot of the things I’ve been thinking are not as simple as they could be in Angular, and a new way of thinking about UI interactions. And I really liked what I found. Now, I know that React is a library, the **V** in MVC while Angular is a full-fledged framework for building MVVM, MVC and MVW web applications. Library != Framework. So while I won’t be making many direct comparisons between the two, I may mention in this article some differences and similarities between them. Overall though, this is an article about what I like about React, and why I think you should take a look at it and try out some examples, even if you don’t intend to make a production application with it.

<!--more-->

## Growth, Decay, Transformation

React, it seems, comes out of a recognition by the engineers at Facebook that at a large scale, the traditional MVC model starts to break down and become extremely complex and hard to change. This is because data is flowing between the Model, Controller and View from many different directions, so when something is changed or needs to be added to any one of them it can cause a lot of unexpected problems down the line. This is exacerbated by global event systems where views can communicate with and change other views without informing the controller or the model. Facebook made a diagram of this, which can be seen below.

![react mvc](/images/reactmvc.png)

The engineers at Facebook decided to extract the View portion out of this equation and transform it into a system where you only need to know what part of your application looks like at any point in time, rather than always considering the myriad other ways it can be changed. In React, this is achieved by implementing a one-way data flow where each component is a black box with its own state, which cannot be modified by other components. This one-way flow from the controller down to the views makes keeping track of the data flowing through your application a lot easier, and lets you locate sources of bugs a lot easier. Facebook’s diagram of how this works is below:

![react diagram](/images/reactd3.png)

## Change

React initially requires you to change the way you think about the UI in your application. Because every component is essentially isolated, the top-down unidirectional data flow becomes very important. You can propagate events to the top component, but you must follow the single path. If you choose to use JSX (it’s optional), you must also rethink how you write your view templates as they are being written inline in JavaScript, so making extremely small components becomes beneficial. Consider a **very** stripped down todo list, with no data access (contrived, I know):

```javascript
// You start with your app component, which you may render on the body or some div inside it

var TodoApp = React.createClass({

    // handles the event bubbled from the NewTodo component
    addTodo: function (newTodo) {
        var todos = this.state.todos;
        todos.push(newTodo);
        this.setState({todos:todos});
    },

    // sets the state object as soon as the component is placed
    getInitialState: function () {
        return { todos: [] };
    },

    // every react component needs this render function
    // which represents how the component should look at
    // any point in time. Note the sub-components.
    render: function () {
        return (
            <div className="todos">
                <NewTodo onNewTodo={this.addTodo}></NewTodo>
                <TodoList todos={this.state.todos}></TodoList>
            </div>
        );
    }
});

// Using JSX to render into the div#todo element, note that the
// component element matches the variable name above.
React.render(
  <TodoApp></TodoApp>,
  document.getElementById('todo')
);
```


As you can see already the top-down flow is coming into action. The TodoApp is the top level component, which has sub-components of NewTodo and TodoList. TodoApp can pass `props` to these components which can be data or event cues such as `onNewTodo`. You will see below how we can use this to work our way up the flow from the subcomponents.

```javascript
// component for creating new todo items. Note that `onSubmit`
// calls `addTodo`, which in turn calls the `props.onNewTodo`
// method which was defined in the TodoApp component above.

var NewTodo = React.createClass({
  render: function () {
    return (
      <form onSubmit={this.addTodo}>
        <input type="text" ref="text" />
        <input type="submit" />
      </form>
    );
  },

  addTodo: function (e) {
    e.preventDefault();
    var newTodo = {
      text: this.refs.text.getDOMNode().value
    };

    this.props.onNewTodo(newTodo);
  }
});
```

In the TodoList component, we can see how data fed down from the top-level component via `props` can be used to re-render the list whenever the top-level component’s state is changed. React will know when this state changes and will trigger the re-render of components that rely on the state.

```javascript
var TodoList = React.createClass({
  render: function () {
    var todos = this.props.todos.map(function (todo) {
      return (<Todo>{todo.text}</Todo>)
    });
    return (
      <div className="todoList">
        {todos}
      </div>
    )
  }
});
```

For completeness, here is the final sub-component, which represents a Todo item:

```javascript
// You can see here how DOM interaction can be used with React.

var Todo = React.createClass({
  delete: function () {
    var el = this.getDOMNode();
    React.unmountComponentAtNode(el);
    el.parentNode.removeChild(el);
  },
  render: function () {
    return (<div>{this.props.children.toString()}<button onClick={this.delete}>Delete</button></div>);
  }
});
```

The way React achieves this re-rendering and change detection is quite unique. For example if you are familiar with Angular you would know that they use a digest cycle that runs constantly to check for changes and watches and then re-renders parts of directives and views directly in the browser based on dirty-checking the models. See the documentation on the [scope life cycle](https://docs.angularjs.org/guide/scope#scope-life-cycle). This two-way data binding system, however, can cause slowdowns with complex or large collections of items.

> With AngularJS, data that is binded to the DOM will trigger a full render of the page whenever it changes. That’s what makes it expensive for large or complex sets of data. <http://wiredcraft.com/blog/why-we-may-ditch-angularjs-for-react/>

React’s approach is to just re-render the parts of components that need to be re-rendered based on changes in props and state. The way that they achieve this is unique and quite performant. React uses a virtual DOM tree that they keep constructed, and whenever a component needs to be re-rendered the render method is run, and its result is diffed with the same component in the virtual DOM to see what has changed. React then queues up all of the DOM manipulations required to achieve this state in the actual DOM and executes them in a batch. This saves them from having to do excessive repaints and reflows which affects users and performances. See this StackOverflow answer from a core React team member that goes into the pros and cons of the virtual DOM in-depth.

[Why is React’s concept of Virtual DOM said to be more performant than dirty model checking?](http://stackoverflow.com/questions/21109361/why-is-reacts-concept-of-virtual-dom-said-to-be-more-performant-than-dirty-mode)

I really like this way of working with the DOM that React has come up with, and it seems (to me, but I’m no algorithmical genius) that this way is a lot better than dirty-checking changes and re-rendering entire parts of the DOM. You may also enjoy Pete Hunt’s talk [The Secrets of React’s Virtual DOM](https://www.youtube.com/watch?v=-DX3vJiqxm4).

## Flux

One thing that I haven’t really covered is how to actually get data to your React components. Because it’s a View/UI library at its core, React doesn’t have a convention for how you should achieve this out of the box. You can use whatever you want to get the data to your components – Backbone Models & Controllers, even Angular! Similarly, routing will be left to a third party framework as well.

For the data management problem, Facebook also has the [Flux](https://facebook.github.io/flux/) library, which is basically a pub-sub system with different data stores. Flux accepts Actions through a Dispatcher, which changes data in various stores and then push the changes to a bunch of different subscribers through events that they have registered to. These subscribers are your React components/views.

While I haven’t looked into React & Flux in-depth, from what I’ve read so far Flux is a little bit tricky to get your head around at first, but from what I’ve seen at the end of the day it looks like a more complex pub-sub system so it shouldn’t be too hard to start using after reading the docs.

## Conclusion

You should definitely take a look at [React](http://facebook.github.io/react/index.html), if anything to just start thinking about different ways the same problem can be solved, and to see a fresh take on a View/Component library. I&#8217;m not saying to switch immediately and jump on the bandwagon and start using it in production today, just that it is an interesting new way of thinking about UI manipulation. Their documentation is excellent and easy to read, and the Getting Started tutorial introduces you to the core concepts really well!
