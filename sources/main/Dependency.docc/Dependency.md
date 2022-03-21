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
// resolving manually
let log = DependencyContainer.resolve() as Logger

final class ObjectWithProtocolDependency {
    
    // resolving with property wrapper
    @Dependency var coordinator: HomeCoordinating
    
    func check() -> String {
        coordinator.start()
    }
}
```

## Topics

### Group

- ``Dependency/Dependency``
- ``Dependency/DependencyContainer``
- ``Dependency/Factory``
