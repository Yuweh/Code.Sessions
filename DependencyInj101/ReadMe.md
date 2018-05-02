### Dependency Injection 101

Dependency Injection is an approach to organizing code so that its dependencies are provided by a different object, instead of by itself. Arranging code like this leads to a codebase of loosely-coupled components that can be tested and refactored.

#### Why Dependency Injection?

Dependency Injection relies on a principle called Inversion of Control. The main idea is that a piece of code that requires some dependencies won’t create them for itself, rather the control over providing these dependencies is deferred to some higher abstraction. These dependencies are typically passed into an object’s initializer. This is the opposite approach — an inverted approach — to the typical cascade of object creation: Object A creating Object B, creating Object C, and so on.

From a practical perspective, the main benefit of Inversion of Control is that code changes remain isolated. A Dependency Injection Container supports the Inversion of Control principal by providing an object that knows how to provide the dependencies for an object. All you need to do is ask the container for the object you need, and voilà… it’s ready

-----
Ref: https://www.raywenderlich.com/182236/swinject-tutorial-for-ios-getting-started
