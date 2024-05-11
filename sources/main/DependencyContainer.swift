import os
import Foundation

public enum Environment: String, Equatable {
    case live
    case preview
    case test
    
    /// Creates an instance for the environment, which is
    /// - .preview for SwiftUI previews
    /// - .test during unit testing
    /// - .live otherwise
    public init() {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            self = .preview
            return
        }
        
        let isRunningTests = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        let isRunningUITests = ProcessInfo().arguments.contains("UI_TEST")
        if isRunningTests || isRunningUITests {
            self = .test
            return
        }
        
        self = .live
    }
}

/**
 Dependency container.
 */
public final class DependencyContainer: CustomDebugStringConvertible
{
    // MARK: - Private

    // Private storage for dependencies.
    private var dependencies = [String: AnyObject]()
    private static let queue = DispatchQueue(label: "thread.DependencyContainer", attributes: .concurrent)

    // Shared container instance
    private static let shared = DependencyContainer()

    // Logger instance.
    private static var log = Logger(subsystem: "Dependency", category: "DependencyContainer")
    private static var isConfigured = false

    public static func configureLogger(subsystem: String, category: String) {
        DependencyContainer.queue.async(flags: .barrier) {
            guard !Self.isConfigured else {
                Self.log.debug("Ignored call. Logger can only be configured once.")
                return
            }
            Self.log = Logger(subsystem: subsystem, category: category)
            Self.isConfigured = true
        }
    }

    // Key to register a type with.
    private static func keyForType<T>(_ type: T.Type, environment: Environment) -> String {
        let typeDescription = String(describing: T.self)
        let preffix = environment.rawValue
        /*
         This relies on the following for Optional detection:
         https://developer.apple.com/documentation/swift/expressiblebynilliteral
         > Only the Optional type conforms to ExpressibleByNilLiteral. ExpressibleByNilLiteral
         conformance for types that use nil for other purposes is discouraged.
         */
        if type is ExpressibleByNilLiteral.Type,
            typeDescription.hasPrefix("Optional<"),
            typeDescription.hasSuffix(">")
        {
            // remove the wrapping "Optional<>" so key is just the type,
            // same as if we had registered a non optional type
            return "\(preffix)." + String(typeDescription.dropFirst("Optional<".count).dropLast())
        } else {
            return "\(preffix)." + typeDescription
        }
    }

    // MARK: - Querying state

    /**
     Returns true if the given type is registered.
     - Parameter dependency: dependency whose registration is being queried.
     - Parameter environment: environment where registration happens.
     - Returns: true if the dependency is registered.
     */
    public static func isRegistered<T>(_ dependency: T.Type, key: String? = nil, environment: Environment = Environment()) -> Bool {
        DependencyContainer.queue.sync {
            let key = key ?? keyForType(T.self, environment: environment)
            return shared.dependencies[key] != nil
        }
    }

    // MARK: - Registering types

    /**
     Register a factory that returns a new instance per request.

     Use it to create an intance per request or to create an instance that uses additional
     dependencies.
     - Parameter factory: An object that creates a new instance of type `T`.
     - Parameter environment: environment where registration happens.
    */
    public static func register<T>(factory: Factory<T>, key: String? = nil, environment: Environment = Environment()) {
        DependencyContainer.queue.async(flags: .barrier) {
            let key = key ?? keyForType(factory.typeCreated.self, environment: environment)
            shared.dependencies[key] = factory as AnyObject
        }
    }

    /**
     Register an instance.

     If the instance is a reference type it will be treated as a singleton.

     - Parameter dependency: instance being registered.
     - Parameter environment: environment where registration happens.
     */
    public static func register<T>(_ dependency: T, key: String? = nil, environment: Environment = Environment()) {
        DependencyContainer.queue.async(flags: .barrier) {
            let key = key ?? keyForType(T.self, environment: environment)
            shared.dependencies[key] = dependency as AnyObject
            log.trace("Registered \(key): \(String(describing: dependency))")
        }
    }

    /// Unregisters all dependencies
    public static func unregisterAll() {
        DependencyContainer.queue.async(flags: .barrier) {
            shared.dependencies = [String: AnyObject]()
        }
    }

    // MARK: - Resolving a type

    /**
     Resolves a dependency previously registered.

     If the dependency is non optional and the type wasn’t previously registered,
     it crashes with preconditionFailure.

     - Returns: resolved instance.
     */
    public static func resolve<T>(key: String? = nil, _ environment: Environment = Environment()) -> T {
        DependencyContainer.queue.sync {
            let key = key ?? keyForType(T.self, environment: environment)

            // the type registered is actually a factory that produces an instance for that type
            if let factory = shared.dependencies[key] as? Factory<T> {
                return factory.create(DependencyContainer.shared)
            }

            guard let dependency = shared.dependencies[key] as? T else {
                if shared.dependencies.keys.contains(key) {
                    preconditionFailure("Wrong type: Key found with type \(type(of: shared.dependencies[key])) but client expected \(T.self)")
                }
                preconditionFailure("Missing dependency: No dependency found for key \(key). The keys I know are: \(shared.dependencies.keys)")
            }
            return dependency
        }
    }
    
    // MARK: - Debugging

    /// Returns a description of the instances registered.
    public static var debugDescription: String {
        DependencyContainer.shared.debugDescription
    }

    /// A textual description of the instances registered, suitable for debugging.
    public var debugDescription: String {
        DependencyContainer.queue.sync {
            """
            Container registered \(dependencies.count) dependencies:
            \t\(dependencies.keys.sorted().joined(separator: "\n\t"))
            """
        }
    }
}

private protocol OptionalProtocol {
    func wrappedType() -> Any.Type
}

extension Optional: OptionalProtocol {
    func wrappedType() -> Any.Type {
        Wrapped.self
    }
}
