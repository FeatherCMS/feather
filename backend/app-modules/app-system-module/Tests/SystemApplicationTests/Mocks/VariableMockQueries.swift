@testable import SystemApplication

actor VariableMockQueries: VariableQueries {
    private(set) var findCallCount = 0
    private(set) var listCallCount = 0
    private(set) var countCallCount = 0
    private(set) var lastFindId: String?
    private(set) var lastListQuery: VariableList.Query?
    private(set) var lastCountQuery: VariableList.Query?

    private let findResult: VariableDetail
    private let listResult: VariableList
    private let countResult: Int

    init(
        findResult: VariableDetail,
        listResult: VariableList,
        countResult: Int
    ) {
        self.findResult = findResult
        self.listResult = listResult
        self.countResult = countResult
    }

    func find(
        id: String
    ) async throws -> VariableDetail {
        findCallCount += 1
        lastFindId = id
        return findResult
    }

    func list(
        query: VariableList.Query
    ) async throws -> VariableList {
        listCallCount += 1
        lastListQuery = query
        return listResult
    }

    func count(
        query: VariableList.Query
    ) async throws -> Int {
        countCallCount += 1
        lastCountQuery = query
        return countResult
    }
}
