import SystemModule

@testable import SystemApplication

extension SystemModule.Permission.List.Query {
    actor Mock: Interface {
        private(set) var listCallCount = 0
        private(set) var lastListQuery:
            SystemModule.Permission.List.Input.Query?

        private let listResult: SystemModule.Permission.List.Output

        init(listResult: SystemModule.Permission.List.Output) {
            self.listResult = listResult
        }

        func list(
            query: SystemModule.Permission.List.Input.Query
        ) async throws -> SystemModule.Permission.List.Output {
            listCallCount += 1
            lastListQuery = query
            return listResult
        }
    }
}
