import Dependency
import XCTest

final class FactoryTests: XCTestCase
{
    func testRegisterResolveType() {
        struct TestType {
            var value: Int
        }
        let factory = Factory<TestType> { _ in TestType(value: 42) }
        DependencyContainer.register(factory: factory)
        let resolved = DependencyContainer.resolve() as TestType
        XCTAssertEqual(resolved.value, 42, "Value registered equals value resolved")
    }

    func testRegisterResolveProtocol() {
        let factory = Factory<HomeCoordinating> { _ in HomeCoordinator() }
        DependencyContainer.register(factory: factory)
        _ = DependencyContainer.resolve() as HomeCoordinating
    }

    func testTypeCreated() {
        struct AnotherTestType {
            var text: String
        }
        let factory = Factory<AnotherTestType> { _ in AnotherTestType(text: "Hello") }
        let createdType = type(of: factory.typeCreated)
        XCTAssertTrue("\(createdType)" == "AnotherTestType.Type", "expected AnotherTestType.Type but got \(createdType)")
    }
}

// MARK: - Test objects

private protocol HomeCoordinating: Sendable {
    func start() -> String
}

private struct HomeCoordinator: HomeCoordinating {
    func start() -> String { "real" }
}
