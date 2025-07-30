/**
 A wrapper for a closure that creates a new instance per request.

 ## Topics

 ### CustomDebugStringConvertible

 - ``Dependency/Factory/debugDescription``

 */
public struct Factory<T>: @unchecked Sendable, CustomDebugStringConvertible {

    /// Creates a new instance.
    /// Having the container as parameter let us query other instances.
    public let create: (DependencyContainer) -> T

    /// Initializes an instance configured instances of type `T`.
    /// - Parameter create: Creates a new instance.
    public init(create: @escaping (DependencyContainer) -> T) {
        self.create = create
    }

    /// Returns the type created by this factory object.
    public var typeCreated: T.Type {
        T.self
    }

    /// MARK: - CustomDebugStringConvertible

    /// A textual description of the type created, suitable for debugging.
    public var debugDescription: String {
        "Factory for type \(typeCreated.self)"
    }
}
