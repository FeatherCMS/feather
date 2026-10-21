import RedirectApplication
import RedirectModule

extension RedirectModule.Rule.Resolve.Query {
    actor Mock: Interface {
        private(set) var resolveCallCount = 0
        private(set) var lastSource: String?

        private let result: RedirectModule.Rule.Resolve.Output?

        init(result: RedirectModule.Rule.Resolve.Output?) {
            self.result = result
        }

        func resolve(
            source: String
        ) async throws -> RedirectModule.Rule.Resolve.Output? {
            resolveCallCount += 1
            lastSource = source
            return result
        }
    }
}
