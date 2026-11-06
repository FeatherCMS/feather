import SystemDomain
import SystemModule

extension SystemModule.Variable.Repository {
    actor Mock: Interface {
        private(set) var lastInsertInput: SystemModule.Variable.Model.New?
        private(set) var insertCallCount = 0
        private(set) var updateCallCount = 0
        private(set) var findCallCount = 0
        private(set) var deleteCallCount = 0
        private(set) var lastFindId: String?
        private(set) var lastFindKey: String?
        private(set) var lastDeleteId: String?

        private let result: Result<SystemModule.Variable.Model, any Error>
        private let findResult: SystemModule.Variable.Model?

        init(
            result: Result<SystemModule.Variable.Model, any Error>,
            findResult: SystemModule.Variable.Model? = nil
        ) {
            self.result = result
            self.findResult = findResult
        }

        func insert(
            _ model: SystemModule.Variable.Model.New
        ) async throws -> SystemModule.Variable.Model {
            insertCallCount += 1
            lastInsertInput = model
            return try result.get()
        }

        func update(
            _ model: SystemModule.Variable.Model
        ) async throws -> SystemModule.Variable.Model {
            updateCallCount += 1
            return model
        }

        func find(id: String) async throws -> SystemModule.Variable.Model? {
            findCallCount += 1
            lastFindId = id
            return findResult
        }

        func find(key: String) async throws -> SystemModule.Variable.Model? {
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
