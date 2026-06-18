@testable import UserApplication

actor MockAccountQueries: AccountQueries {
    private(set) var listCallCount = 0
    private(set) var countCallCount = 0
    private(set) var getByCallCount = 0
    private(set) var rolesCallCount = 0
    private(set) var permissionsCallCount = 0

    private let detailResult: AccountDetail
    private let listResult: AccountList
    private let countResult: Int
    private let rolesResult: [String]
    private let permissionsResult: [String]

    init(
        detailResult: AccountDetail,
        listResult: AccountList,
        countResult: Int,
        rolesResult: [String] = [],
        permissionsResult: [String] = []
    ) {
        self.detailResult = detailResult
        self.listResult = listResult
        self.countResult = countResult
        self.rolesResult = rolesResult
        self.permissionsResult = permissionsResult
    }

    func list(
        query: AccountList.Query
    ) async throws -> AccountList {
        listCallCount += 1
        return listResult
    }

    func count(
        query: AccountList.Query
    ) async throws -> Int {
        countCallCount += 1
        return countResult
    }

    func getBy(
        id: String
    ) async throws -> AccountDetail {
        getByCallCount += 1
        return detailResult
    }

    func getRolesBy(
        accountId: String
    ) async throws -> [String] {
        rolesCallCount += 1
        return rolesResult
    }

    func getPermissionsBy(
        accountId: String
    ) async throws -> [String] {
        permissionsCallCount += 1
        return permissionsResult
    }
}
