import SystemModule

@testable import SystemApplication

extension SystemModule.Variable.List.Query {
    actor Mock: Interface {
        private(set) var listCallCount = 0
        private(set) var countCallCount = 0
        private(set) var lastListQuery: SystemModule.Variable.List.Input.Query?
        private(set) var lastCountQuery: SystemModule.Variable.List.Input.Query?

        private let listResult: SystemModule.Variable.List.Output
        private let countResult: Int

        init(
            listResult: SystemModule.Variable.List.Output,
            countResult: Int
        ) {
            self.listResult = listResult
            self.countResult = countResult
        }

        func list(
            query: SystemModule.Variable.List.Input.Query
        ) async throws -> SystemModule.Variable.List.Output {
            listCallCount += 1
            lastListQuery = query
            return listResult
        }

        func count(
            query: SystemModule.Variable.List.Input.Query
        ) async throws -> Int {
            countCallCount += 1
            lastCountQuery = query
            return countResult
        }
    }
}
