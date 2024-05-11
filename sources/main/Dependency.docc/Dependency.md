# ``Dependency``

[Dependency injection through property wrappers](https://janodev.github.io/Dependency/documentation/dependency/).

## Overview

![Dependency](Dependency)

### Registering types

```swift
// injecting a type
DependencyContainer.register(HomeCoordinator())

// injecting a type as a protocol
DependencyContainer.register(MockHomeCoordinator() as HomeCoordinating)

// using a factory
let factory = Factory { container in HomeCoordinator() }
DependencyContainer.register(factory: factory)
```

### Resolving

```swift
// resolving manually, crashes if instance is not registered
let log = DependencyContainer.resolve() as Logger
let log: Logger = DependencyContainer.resolve()

// when resolving as optional, no crash happens if instance is not registered
let log: Logger? = DependencyContainer.resolve()

final class ObjectWithProtocolDependency {
    
    // resolving with property wrapper
    @Dependency var coordinator: HomeCoordinating
    
    func check() -> String {
        coordinator.start()
    }
}
```

### Register for environment

Instances are registered for live, preview, test, depending on the environment.
You can also register or resolve for a specific environment.
```swift
DependencyContainer.register(SomeObject(), environment: .test)
DependencyContainer.resolve(environment: .test) as SomeObject
```


## Topics

### Group

- ``Dependency/Dependency``
- ``Dependency/DependencyContainer``
- ``Dependency/Factory``
