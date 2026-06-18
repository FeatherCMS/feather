import Foundation
import UserApplication
@testable import AuthApplication

actor MockMagicLinkQueries: MagicLinkQueries {
    private(set) var listCallCount = 0
    private(set) var countCallCount = 0

    private let listResult: MagicLinkList
    private let countResult: Int

    init(
        listResult: MagicLinkList,
        countResult: Int
    ) {
        self.listResult = listResult
        self.countResult = countResult
    }

    func list(
        query: MagicLinkList.Query
    ) async throws -> MagicLinkList {
        listCallCount += 1
        return listResult
    }

    func count(
        query: MagicLinkList.Query
    ) async throws -> Int {
        countCallCount += 1
        return countResult
    }
}

actor MockRolePermissionQueries: RolePermissionQueries {
    private(set) var listCallCount = 0
    private(set) var countCallCount = 0

    private let listResult: RolePermissionList
    private let countResult: Int

    init(
        listResult: RolePermissionList,
        countResult: Int
    ) {
        self.listResult = listResult
        self.countResult = countResult
    }

    func permissions(
        for roleIds: Set<String>
    ) async throws -> Set<String> {
        []
    }

    func getBy(
        roleId: String,
        permissionId: String
    ) async throws -> RolePermissionDetail {
        fatalError("not needed in tests")
    }

    func list(
        query: RolePermissionList.Query
    ) async throws -> RolePermissionList {
        listCallCount += 1
        return listResult
    }

    func count(
        query: RolePermissionList.Query
    ) async throws -> Int {
        countCallCount += 1
        return countResult
    }
}

actor MockSessionQueries: SessionQueries {
    private let findResult: SessionDetail
    private(set) var listCallCount = 0
    private(set) var findCallCount = 0
    private(set) var lastQuery: SessionList.Query?
    private let listResult: SessionList

    init(
        findResult: SessionDetail = .init(
            id: "session-1",
            token: "token-1",
            accountId: "account-1",
            expiresAt: 123_456,
            isPersistent: true,
            createdAt: .init(timeIntervalSince1970: 1),
            updatedAt: .init(timeIntervalSince1970: 2)
        ),
        listResult: SessionList
    ) {
        self.findResult = findResult
        self.listResult = listResult
    }

    func find(
        id: String
    ) async throws -> SessionDetail {
        findCallCount += 1
        return findResult
    }

    func list(
        query: SessionList.Query
    ) async throws -> SessionList {
        listCallCount += 1
        lastQuery = query
        return listResult
    }
}

struct DummyAccountQueries: AccountQueries {
    func list(
        query: AccountList.Query
    ) async throws -> AccountList {
        .init(items: [])
    }

    func count(
        query: AccountList.Query
    ) async throws -> Int {
        0
    }

    func getBy(
        id: String
    ) async throws -> AccountDetail {
        fatalError("not needed in tests")
    }

    func getRolesBy(
        accountId: String
    ) async throws -> [String] {
        []
    }

    func getRoleIdsBy(
        accountId: String
    ) async throws -> [String] {
        []
    }

    func getPermissionsBy(
        accountId: String
    ) async throws -> [String] {
        []
    }
}
