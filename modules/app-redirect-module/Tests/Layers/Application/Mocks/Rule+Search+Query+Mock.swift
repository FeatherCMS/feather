import RedirectApplication
import RedirectModule

extension RedirectModule.Rule.Search.Query {
    actor Mock: Interface {
        private(set) var searchCallCount = 0
        private(set) var lastQuery: RedirectModule.Rule.Search.Input.Query?

        private let result: RedirectModule.Rule.Search.Output

        init(result: RedirectModule.Rule.Search.Output) {
            self.result = result
        }

        func search(
            query: RedirectModule.Rule.Search.Input.Query
        ) async throws -> RedirectModule.Rule.Search.Output {
            searchCallCount += 1
            lastQuery = query
            return result
        }
    }
}
