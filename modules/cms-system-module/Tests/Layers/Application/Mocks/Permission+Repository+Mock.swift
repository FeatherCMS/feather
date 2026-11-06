import SystemDomain
import SystemModule

extension SystemModule.Permission.Repository {
    actor Mock: Interface {
        private(set) var lastInsertInput: SystemModule.Permission.Model.New?
        private(set) var insertCallCount = 0
        private(set) var updateCallCount = 0
        private(set) var findCallCount = 0
        private(set) var deleteCallCount = 0
        private(set) var lastFindId: String?
        private(set) var lastFindKey: String?
        private(set) var lastDeleteId: String?

        private let result: Result<SystemModule.Permission.Model, any Error>
        private let findResult: SystemModule.Permission.Model?

        init(
            result: Result<SystemModule.Permission.Model, any Error>,
            findResult: SystemModule.Permission.Model? = nil
        ) {
            self.result = result
            self.findResult = findResult
        }

        func insert(
            _ model: SystemModule.Permission.Model.New
        ) async throws -> SystemModule.Permission.Model {
            insertCallCount += 1
            lastInsertInput = model
            return try result.get()
        }

        func update(
            _ model: SystemModule.Permission.Model
        ) async throws -> SystemModule.Permission.Model {
            updateCallCount += 1
            return model
        }

        func find(id: String) async throws -> SystemModule.Permission.Model? {
            findCallCount += 1
            lastFindId = id
            return findResult
        }

        func find(key: String) async throws -> SystemModule.Permission.Model? {
            findCallCount += 1
            lastFindKey = key
            return findResult
        }

        func delete(ids: [String]) async throws {
            deleteCallCount += 1
            lastDeleteId = ids.first
        }
    }
}
