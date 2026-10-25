import SystemModule

@testable import SystemApplication

extension SystemModule.Variable.List.Query {
    actor Mock: Interface {
        private(set) var listCallCount = 0
        private(set) var lastListQuery: SystemModule.Variable.List.Input.Query?

        private let listResult: SystemModule.Variable.List.Output

        init(listResult: SystemModule.Variable.List.Output) {
            self.listResult = listResult
        }

        func list(
            query: SystemModule.Variable.List.Input.Query
        ) async throws -> SystemModule.Variable.List.Output {
            listCallCount += 1
            lastListQuery = query
            return listResult
        }
    }
}
