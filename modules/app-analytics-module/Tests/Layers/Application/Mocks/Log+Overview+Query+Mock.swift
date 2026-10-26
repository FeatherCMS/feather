import AnalyticsModule

@testable import AnalyticsApplication

extension Log.Overview.Query {
    actor Mock: Interface {
        private let result: Log.Overview.Output?
        private(set) var overviewCallCount = 0
        private(set) var lastQuery: Log.Overview.Input.Query?

        init(result: Log.Overview.Output? = nil) {
            self.result = result
        }

        func overview(
            query: Log.Overview.Input.Query
        ) async throws -> Log.Overview.Output {
            overviewCallCount += 1
            lastQuery = query
            guard let result else {
                throw CancellationError()
            }
            return result
        }
    }
}
