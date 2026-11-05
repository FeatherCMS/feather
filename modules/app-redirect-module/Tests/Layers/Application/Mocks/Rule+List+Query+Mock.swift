import RedirectApplication
import RedirectModule

extension Rule.List.Query {
    actor Mock: Interface {
        private(set) var listCallCount = 0

        private let result: Rule.List.Output

        init(result: Rule.List.Output) {
            self.result = result
        }

        func list() async throws -> Rule.List.Output {
            listCallCount += 1
            return result
        }
    }
}
