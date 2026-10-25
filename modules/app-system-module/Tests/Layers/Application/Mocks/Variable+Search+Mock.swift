import SystemModule

@testable import SystemApplication

extension SystemModule.Variable.Search {
    actor Mock: Query.Interface {
        private(set) var searchCallCount = 0
        private(set) var lastQuery: Input.Query?

        private let result: Output

        init(result: Output) {
            self.result = result
        }

        func search(
            query: Input.Query
        ) async throws -> Output {
            searchCallCount += 1
            lastQuery = query
            return result
        }
    }
}
