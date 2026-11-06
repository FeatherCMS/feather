import NewsModule

@testable import NewsApplication

extension Category.Search.Query {
    actor Mock: Interface {
        private let result: Category.Search.Output?
        private(set) var searchCallCount = 0
        private(set) var lastSearch: Category.Search.Input.Query?

        init(result: Category.Search.Output? = nil) {
            self.result = result
        }

        func search(
            query: Category.Search.Input.Query
        ) async throws -> Category.Search.Output {
            searchCallCount += 1
            lastSearch = query
            guard let result else {
                throw CancellationError()
            }
            return result
        }
    }
}
