import SystemModule

@testable import SystemApplication

extension SystemModule.Permission.List.Query {
    actor Mock: Interface {
        private(set) var listCallCount = 0
        private(set) var countCallCount = 0
        private(set) var lastListQuery:
            SystemModule.Permission.List.Input.Query?
        private(set) var lastCountQuery:
            SystemModule.Permission.List.Input.Query?

        private let listResult: SystemModule.Permission.List.Output
        private let countResult: Int

        init(
            listResult: SystemModule.Permission.List.Output,
            countResult: Int
        ) {
            self.listResult = listResult
            self.countResult = countResult
        }

        func list(
            query: SystemModule.Permission.List.Input.Query
        ) async throws -> SystemModule.Permission.List.Output {
            listCallCount += 1
            lastListQuery = query
            return listResult
        }

        func count(
            query: SystemModule.Permission.List.Input.Query
        ) async throws -> Int {
            countCallCount += 1
            lastCountQuery = query
            return countResult
        }
    }
}
