import RedirectApplication
import RedirectModule

extension Rule.Detail.Query {
    actor Mock: Interface {
        private(set) var detailCallCount = 0
        private(set) var lastID: String?

        private let result: Rule.Detail.Output

        init(result: Rule.Detail.Output) {
            self.result = result
        }

        func detail(id: String) async throws -> Rule.Detail.Output {
            detailCallCount += 1
            lastID = id
            return result
        }
    }
}
