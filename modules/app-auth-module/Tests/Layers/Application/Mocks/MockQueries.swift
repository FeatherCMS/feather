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
    MagicLink.List.Query.Interface
{
    private(set) var findCallCount = 0
    private(set) var listCallCount = 0
    private(set) var countCallCount = 0
    private(set) var lastFindId: String?
    private(set) var lastListQuery: MagicLink.List.Input.Query?

    private let findResult: MagicLink.Detail.Output
    private let listResult: MagicLink.List.Output
    private let countResult: Int

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
        listResult: MagicLink.List.Output,
        countResult: Int
    ) {
        self.findResult = findResult
        self.listResult = listResult
        self.countResult = countResult
    }

    func find(
        id: String
    ) async throws -> MagicLink.Detail.Output {
        findCallCount += 1
        lastFindId = id
        return findResult
    }

    func list(
        query: MagicLink.List.Input.Query
    ) async throws -> MagicLink.List.Output {
        listCallCount += 1
        lastListQuery = query
        return listResult
    }

    func count(
        query: MagicLink.List.Input.Query
    ) async throws -> Int {
        countCallCount += 1
        return countResult
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
    Session.List.Query.Interface,
    Session.ListByIdentity.Query.Interface
{
    private let findResult: Session.Detail.Output
    private(set) var listCallCount = 0
    private(set) var findCallCount = 0
    private(set) var lastQuery: Session.List.Input.Query?
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

    func list(
        query: Session.List.Input.Query
    ) async throws -> Session.List.Output {
        listCallCount += 1
        lastQuery = query
        return listResult
    }

    func list(identityId: String) async throws -> Session.ListByIdentity.Output
    {
        listCallCount += 1
        lastQuery = .init(identityId: identityId)
        return .init(
            items: listResult.items
                .filter { $0.identityId == identityId }
                .map {
                    .init(
                        id: $0.id,
                        token: $0.token,
                        identityId: $0.identityId,
                        authenticationType: $0.authenticationType,
                        authenticationReference: $0.authenticationReference,
                        expiresAt: $0.expiresAt,
                        isPersistent: $0.isPersistent,
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                }
        )
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
