import Dependency
import XCTest

final class EnvironmentTests: XCTestCase {
    override func setUp() {
        super.setUp()
        DependencyContainer.unregisterAll()
    }

    func testRegistrationForEnvironment() {
        let live = Environment.live.rawValue
        let preview = Environment.preview.rawValue
        let test = Environment.test.rawValue

        DependencyContainer.register(live, environment: .live)
        DependencyContainer.register(preview, environment: .preview)
        DependencyContainer.register(test, environment: .test)

        XCTAssertEqual(Environment.live.rawValue, DependencyContainer.resolve(.live))
        XCTAssertEqual(Environment.preview.rawValue, DependencyContainer.resolve(.preview))
        XCTAssertEqual(Environment.test.rawValue, DependencyContainer.resolve(.test))
    }

    func testDefaultRegistrationForTesting() {
        let object = Environment.test.rawValue
        DependencyContainer.register(object)
        XCTAssertEqual(Environment.test.rawValue, DependencyContainer.resolve(.test) as String)
    }
}
