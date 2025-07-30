import Dependency
import XCTest

final class EnvironmentTests: XCTestCase {
    override func setUp() {
        super.setUp()
        DependencyContainer.unregisterAll()
    }

    func testRegistrationForEnvironment() {
        let live = DependencyContainer.RuntimeEnvironment.live.rawValue
        let preview = DependencyContainer.RuntimeEnvironment.preview.rawValue
        let test = DependencyContainer.RuntimeEnvironment.test.rawValue

        DependencyContainer.register(live, environment: .live)
        DependencyContainer.register(preview, environment: .preview)
        DependencyContainer.register(test, environment: .test)

        XCTAssertEqual(DependencyContainer.RuntimeEnvironment.live.rawValue, DependencyContainer.resolve(.live))
        XCTAssertEqual(DependencyContainer.RuntimeEnvironment.preview.rawValue, DependencyContainer.resolve(.preview))
        XCTAssertEqual(DependencyContainer.RuntimeEnvironment.test.rawValue, DependencyContainer.resolve(.test))
    }

    func testDefaultRegistrationForTesting() {
        let object = DependencyContainer.RuntimeEnvironment.test.rawValue
        // Register in test environment explicitly since that's where we'll resolve from
        DependencyContainer.register(object, environment: .test)
        XCTAssertEqual(DependencyContainer.RuntimeEnvironment.test.rawValue, DependencyContainer.resolve(.test) as String)
    }
}
