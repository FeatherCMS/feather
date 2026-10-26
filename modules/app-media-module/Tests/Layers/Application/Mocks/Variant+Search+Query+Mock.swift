import MediaModule

@testable import MediaApplication

extension Variant.Search.Query {
    actor Mock: Interface {
        private(set) var searchCallCount = 0
        private(set) var lastQuery: Variant.Search.Input.Query?
        private let result: Variant.Search.Output

        init(result: Variant.Search.Output) {
            self.result = result
        }

        func search(
            query: Variant.Search.Input.Query
        ) async throws -> Variant.Search.Output {
            searchCallCount += 1
            lastQuery = query
            return result
        }
    }
}
