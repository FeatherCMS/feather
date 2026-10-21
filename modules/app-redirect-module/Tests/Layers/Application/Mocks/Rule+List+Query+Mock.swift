import RedirectApplication
import RedirectModule

extension RedirectModule.Rule.List.Query {
    actor Mock: Interface {
        private(set) var listCallCount = 0

        private let result: RedirectModule.Rule.List.Output

        init(result: RedirectModule.Rule.List.Output) {
            self.result = result
        }

        func list() async throws -> RedirectModule.Rule.List.Output {
            listCallCount += 1
            return result
        }
    }
}
