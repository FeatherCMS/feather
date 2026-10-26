import ContactModule

@testable import ContactApplication

extension Form.List.Query {
    actor Mock: Interface {
        private let result: Form.List.Output?
        private(set) var listCallCount = 0

        init(result: Form.List.Output? = nil) {
            self.result = result
        }

        func list() async throws -> Form.List.Output {
            listCallCount += 1
            guard let result else {
                throw CancellationError()
            }
            return result
        }
    }
}
