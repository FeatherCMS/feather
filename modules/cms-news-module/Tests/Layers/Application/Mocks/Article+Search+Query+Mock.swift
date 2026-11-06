import NewsModule

@testable import NewsApplication

extension Article.Search.Query {
    actor Mock: Interface {
        private let result: Article.Search.Output?
        private(set) var searchCallCount = 0
        private(set) var lastSearch: Article.Search.Input.Query?

        init(result: Article.Search.Output? = nil) {
            self.result = result
        }

        func search(
            query: Article.Search.Input.Query
        ) async throws -> Article.Search.Output {
            searchCallCount += 1
            lastSearch = query
            guard let result else {
                throw CancellationError()
            }
            return result
        }
    }
}
