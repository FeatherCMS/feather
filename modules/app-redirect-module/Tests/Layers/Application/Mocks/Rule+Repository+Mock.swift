import RedirectDomain
import RedirectModule

extension Rule.Repository {
    actor Mock: Interface {
        private(set) var lastInsertInput: Rule.Model.New?
        private(set) var insertCallCount = 0
        private(set) var updateCallCount = 0
        private(set) var findCallCount = 0
        private(set) var deleteCallCount = 0
        private(set) var lastFindID: String?
        private(set) var lastFindSource: String?
        private(set) var lastDeleteIDs: [String]?

        private let result: Result<Rule.Model, any Error>
        private let findResult: Rule.Model?
        private let deleteResult: Bool

        init(
            result: Result<Rule.Model, any Error>,
            findResult: Rule.Model? = nil,
            deleteResult: Bool = false
        ) {
            self.result = result
            self.findResult = findResult
            self.deleteResult = deleteResult
        }

        func insert(
            _ model: Rule.Model.New
        ) async throws -> Rule.Model {
            insertCallCount += 1
            lastInsertInput = model
            return try result.get()
        }

        func update(
            _ model: Rule.Model
        ) async throws -> Rule.Model {
            updateCallCount += 1
            return model
        }

        func find(id: String) async throws -> Rule.Model? {
            findCallCount += 1
            lastFindID = id
            return findResult
        }

        func find(source: String) async throws -> Rule.Model? {
            findCallCount += 1
            lastFindSource = source
            return findResult
        }

        func delete(ids: [String]) async throws -> [String] {
            deleteCallCount += 1
            lastDeleteIDs = ids
            return deleteResult ? ids : []
        }
    }
}
