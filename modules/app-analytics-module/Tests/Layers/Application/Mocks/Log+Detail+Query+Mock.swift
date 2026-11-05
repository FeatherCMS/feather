import AnalyticsModule

@testable import AnalyticsApplication

extension Log.Detail.Query {
    actor Mock: Interface {
        private let result: Log.Detail.Output?
        private(set) var findCallCount = 0
        private(set) var lastID: String?

        init(result: Log.Detail.Output? = nil) {
            self.result = result
        }

        func find(id: String) async throws -> Log.Detail.Output {
            findCallCount += 1
            lastID = id
            guard let result else {
                throw CancellationError()
            }
            return result
        }
    }
}
