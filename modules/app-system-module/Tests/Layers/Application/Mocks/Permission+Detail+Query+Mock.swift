import SystemModule

@testable import SystemApplication

extension SystemModule.Permission.Detail.Query {
    actor Mock: Interface {
        private(set) var findCallCount = 0
        private(set) var lastFindID: String?

        private let result: SystemModule.Permission.Detail.Output

        init(result: SystemModule.Permission.Detail.Output) {
            self.result = result
        }

        func find(
            id: String
        ) async throws -> SystemModule.Permission.Detail.Output {
            findCallCount += 1
            lastFindID = id
            return result
        }
    }
}
