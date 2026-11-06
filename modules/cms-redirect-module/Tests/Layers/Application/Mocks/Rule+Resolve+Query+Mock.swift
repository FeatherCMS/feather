import RedirectApplication
import RedirectModule

extension Rule.Resolve.Query {
    actor Mock: Interface {
        private(set) var resolveCallCount = 0
        private(set) var lastSource: String?

        private let result: Rule.Resolve.Output?

        init(result: Rule.Resolve.Output?) {
            self.result = result
        }

        func resolve(
            source: String
        ) async throws -> Rule.Resolve.Output? {
            resolveCallCount += 1
            lastSource = source
            return result
        }
    }
}
