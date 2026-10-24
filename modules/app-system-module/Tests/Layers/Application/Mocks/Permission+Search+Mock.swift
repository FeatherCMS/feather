import SystemModule

@testable import SystemApplication

extension SystemModule.Permission.Search {
    actor Mock: Query.Interface {
        private(set) var searchCallCount = 0
        private(set) var lastQuery: SystemModule.Permission.Search.Input.Query?

        private let result: SystemModule.Permission.Search.Output

        init(result: SystemModule.Permission.Search.Output) {
            self.result = result
        }

        func search(
            query: SystemModule.Permission.Search.Input.Query
        ) async throws -> SystemModule.Permission.Search.Output {
            searchCallCount += 1
            lastQuery = query
            return result
        }
    }
}
