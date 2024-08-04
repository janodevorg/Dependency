import Dependency
import XCTest

final class ThreadSafetyTests: XCTestCase
{
    override func setUp() {
        super.setUp()
        DependencyContainer.unregisterAll()
    }

    func testThreadSafety() {
        let expectation = XCTestExpectation(description: "Concurrent accesses should complete without error")
        let numberOfThreads = 50
        let dispatchGroup = DispatchGroup()

        for i in 0..<numberOfThreads {
            dispatchGroup.enter()

            DispatchQueue.global(qos: .userInitiated).async {
                let factory = Factory<Int> { _ in
                    return i
                }

                DependencyContainer.register(factory: factory, key: "\(i)", environment: .test)
                let resolved: Int = DependencyContainer.resolve(key: "\(i)", DependencyContainer.RuntimeEnvironment.test)
                XCTAssertEqual(resolved, i, "Resolved dependency should match the registered value")

                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            expectation.fulfill() // all tasks completed
        }

        wait(for: [expectation], timeout: 10.0)
    }

    override func tearDown() {
        super.tearDown()
        DependencyContainer.unregisterAll()
    }
}
