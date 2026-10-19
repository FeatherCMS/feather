import SystemModule

@testable import SystemApplication

extension SystemModule.Variable.Search {
    actor Mock: Interface {
        private(set) var searchCallCount = 0
        private(set) var lastQuery: SystemModule.Variable.Search.Input.Query?

        private let result: SystemModule.Variable.Search.Output

        init(result: SystemModule.Variable.Search.Output) {
            self.result = result
        }

        func search(
            query: SystemModule.Variable.Search.Input.Query
        ) async throws -> SystemModule.Variable.Search.Output {
            searchCallCount += 1
            lastQuery = query
            return result
        }
    }
}
