import NewsModule

@testable import NewsApplication

extension Category.List.Query {
    actor Mock: Interface {
        private let result: Category.List.Output?
        private(set) var listCallCount = 0

        init(result: Category.List.Output? = nil) {
            self.result = result
        }

        func list() async throws -> Category.List.Output {
            listCallCount += 1
            guard let result else {
                throw CancellationError()
            }
            return result
        }
    }
}
