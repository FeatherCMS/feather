import RedirectApplication
import RedirectModule

extension RedirectModule.Rule.Detail.Query {
    actor Mock: Interface {
        private(set) var detailCallCount = 0
        private(set) var lastID: String?

        private let result: RedirectModule.Rule.Detail.Output

        init(result: RedirectModule.Rule.Detail.Output) {
            self.result = result
        }

        func detail(id: String) async throws -> RedirectModule.Rule.Detail.Output {
            detailCallCount += 1
            lastID = id
            return result
        }
    }
}
