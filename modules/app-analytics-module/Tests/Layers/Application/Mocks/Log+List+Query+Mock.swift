import AnalyticsModule

@testable import AnalyticsApplication

extension Log.List.Query {
    actor Mock: Interface {
        private let result: Log.List.Output?
        private let countResult: Int
        private(set) var listCallCount = 0
        private(set) var countCallCount = 0
        private(set) var lastListQuery: Log.List.Input.Query?
        private(set) var lastCountQuery: Log.List.Input.Query?

        init(result: Log.List.Output? = nil, countResult: Int = 0) {
            self.result = result
            self.countResult = countResult
        }

        func list(query: Log.List.Input.Query) async throws -> Log.List.Output {
            listCallCount += 1
            lastListQuery = query
            guard let result else {
                throw CancellationError()
            }
            return result
        }

        func count(query: Log.List.Input.Query) async throws -> Int {
            countCallCount += 1
            lastCountQuery = query
            return countResult
        }
    }
}
