@testable import SystemApplication

actor PermissionMockQueries: PermissionQueries {
    private(set) var findCallCount = 0
    private(set) var listCallCount = 0
    private(set) var countCallCount = 0
    private(set) var lastFindId: String?
    private(set) var lastListQuery: PermissionList.Query?
    private(set) var lastCountQuery: PermissionList.Query?

    private let findResult: PermissionDetail
    private let listResult: PermissionList
    private let countResult: Int

    init(
        findResult: PermissionDetail,
        listResult: PermissionList,
        countResult: Int
    ) {
        self.findResult = findResult
        self.listResult = listResult
        self.countResult = countResult
    }

    func find(
        id: String
    ) async throws -> PermissionDetail {
        findCallCount += 1
        lastFindId = id
        return findResult
    }

    func list(
        query: PermissionList.Query
    ) async throws -> PermissionList {
        listCallCount += 1
        lastListQuery = query
        return listResult
    }

    func count(
        query: PermissionList.Query
    ) async throws -> Int {
        countCallCount += 1
        lastCountQuery = query
        return countResult
    }
}
