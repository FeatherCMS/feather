import RedirectApplication
import RedirectModule

extension Rule.Search.Query {
    actor Mock: Interface {
        private(set) var searchCallCount = 0
        private(set) var lastQuery: Rule.Search.Input.Query?

        private let result: Rule.Search.Output

        init(result: Rule.Search.Output) {
            self.result = result
        }

        func search(
            query: Rule.Search.Input.Query
        ) async throws -> Rule.Search.Output {
            searchCallCount += 1
            lastQuery = query
            return result
        }
    }
}
