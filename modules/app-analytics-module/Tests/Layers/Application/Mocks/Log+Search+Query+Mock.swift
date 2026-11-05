import AnalyticsModule

@testable import AnalyticsApplication

extension Log.Search.Query {
    actor Mock: Interface {
        private let result: Log.Search.Output?
        private(set) var searchCallCount = 0
        private(set) var lastQuery: Log.Search.Input.Query?

        init(result: Log.Search.Output? = nil) {
            self.result = result
        }

        func search(
            query: Log.Search.Input.Query
        ) async throws -> Log.Search.Output {
            searchCallCount += 1
            lastQuery = query
            guard let result else {
                throw CancellationError()
            }
            return result
        }
    }
}
