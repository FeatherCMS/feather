import ContactModule

@testable import ContactApplication

extension Form.Search.Query {
    actor Mock: Interface {
        private let result: Form.Search.Output?
        private(set) var searchCallCount = 0
        private(set) var lastSearch: Form.Search.Input.Query?

        init(result: Form.Search.Output? = nil) {
            self.result = result
        }

        func search(
            query: Form.Search.Input.Query
        ) async throws -> Form.Search.Output {
            searchCallCount += 1
            lastSearch = query
            guard let result else {
                throw CancellationError()
            }
            return result
        }
    }
}
