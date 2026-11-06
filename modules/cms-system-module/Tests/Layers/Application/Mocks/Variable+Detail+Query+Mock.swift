import SystemDomain
import SystemModule

@testable import SystemApplication

extension SystemModule.Variable.Detail.Query {
    actor Mock: Interface {
        private(set) var findCallCount = 0
        private(set) var lastFindID: String?

        private let result: SystemModule.Variable.Model

        init(result: SystemModule.Variable.Model) {
            self.result = result
        }

        func find(id: String) async throws -> SystemModule.Variable.Model {
            findCallCount += 1
            lastFindID = id
            return result
        }
    }
}
