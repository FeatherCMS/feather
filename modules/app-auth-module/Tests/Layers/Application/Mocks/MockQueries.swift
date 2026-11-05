import AuthDomain
import AuthModule
import Foundation
import UserApplication
import UserModule

@testable import AuthApplication

//
//  MockQueries.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

actor MockMagicLinkQueries: MagicLink.Detail.Query.Interface,
    MagicLink.Search.Query.Interface
{
    private(set) var findCallCount = 0
    private(set) var searchCallCount = 0
    private(set) var lastFindId: String?
    private(set) var lastSearchQuery: MagicLink.Search.Input.Query?

    private let findResult: MagicLink.Detail.Output
    private let searchResult: MagicLink.Search.Output

    init(
        findResult: MagicLink.Detail.Output = .init(
            id: "magic-link-1",
            authEmailId: "auth-email-1",
            token: "token-1",
            expiresAt: .init(timeIntervalSince1970: 123_456),
            isPersistent: true,
            isUsed: false,
            createdAt: .init(timeIntervalSince1970: 1),
            updatedAt: .init(timeIntervalSince1970: 2)
        ),
        searchResult: MagicLink.Search.Output
    ) {
        self.findResult = findResult
        self.searchResult = searchResult
    }

    func find(
        id: String
    ) async throws -> MagicLink.Detail.Output {
        findCallCount += 1
        lastFindId = id
        return findResult
    }

    func search(
        query: MagicLink.Search.Input.Query
    ) async throws -> MagicLink.Search.Output {
        searchCallCount += 1
        lastSearchQuery = query
        return searchResult
    }
}

actor MockAuthEmailSearchQuery: Email.Search.Query.Interface {
    private(set) var searchCallCount = 0
    private(set) var lastQuery: Email.Search.Input.Query?
    private let result: Email.Search.Output

    init(result: Email.Search.Output) {
        self.result = result
    }

    func search(
        query: Email.Search.Input.Query
    ) async throws -> Email.Search.Output {
        searchCallCount += 1
        lastQuery = query
        return result
    }
}

actor MockRolePermissionQueries: RolePermission.Search.Query.Interface {
    private(set) var searchCallCount = 0
    private(set) var countCallCount = 0

    private let searchResult: RolePermission.Search.Output
    private let countResult: Int

    init(
        searchResult: RolePermission.Search.Output,
        countResult: Int
    ) {
        self.searchResult = searchResult
        self.countResult = countResult
    }

    func search(
        query: RolePermission.Search.Input.Query
    ) async throws -> RolePermission.Search.Output {
        searchCallCount += 1
        return searchResult
    }

    func count(
        query: RolePermission.Search.Input.Query
    ) async throws -> Int {
        countCallCount += 1
        return countResult
    }
}

actor MockSessionQueries: Session.Detail.Query.Interface,
    Session.List.Query.Interface
{
    private let findResult: Session.Detail.Output
    private(set) var listCallCount = 0
    private(set) var findCallCount = 0
    private(set) var lastIdentityId: String?
    private let listResult: Session.List.Output

    init(
        findResult: Session.Detail.Output = .init(
            id: "session-1",
            token: "token-1",
            identityId: "identity-1",
            authenticationType: Session.Model.AuthenticationTypes
                .credential,
            authenticationReference: "credential-1",
            expiresAt: 123_456,
            isPersistent: true,
            createdAt: .init(timeIntervalSince1970: 1),
            updatedAt: .init(timeIntervalSince1970: 2)
        ),
        listResult: Session.List.Output
    ) {
        self.findResult = findResult
        self.listResult = listResult
    }

    func find(
        id: String
    ) async throws -> Session.Detail.Output {
        findCallCount += 1
        return findResult
    }

    func list(identityId: String) async throws -> Session.List.Output {
        listCallCount += 1
        lastIdentityId = identityId
        return listResult
    }
}

struct DummyAuthorizationQueries: Authorization.Roles.Query.Interface,
    Authorization.Permissions.Query.Interface
{
    func getRolesBy(
        identityId: String
    ) async throws -> [String] {
        ["editor"]
    }

    func getPermissionsBy(
        identityId: String
    ) async throws -> [String] {
        ["account:read"]
    }
}
