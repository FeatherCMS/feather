@testable import UserApplication

actor MockRoleQueries: RoleQueries {
    private(set) var listCallCount = 0
    private(set) var countCallCount = 0

    private let detailResult: RoleDetail
    private let listResult: RoleList
    private let countResult: Int

    init(
        detailResult: RoleDetail,
        listResult: RoleList,
        countResult: Int
    ) {
        self.detailResult = detailResult
        self.listResult = listResult
        self.countResult = countResult
    }

    func list(
        query: RoleList.Query
    ) async throws -> RoleList {
        listCallCount += 1
        return listResult
    }

    func count(
        query: RoleList.Query
    ) async throws -> Int {
        countCallCount += 1
        return countResult
    }

    func getBy(
        id: String
    ) async throws -> RoleDetail {
        detailResult
    }
}
