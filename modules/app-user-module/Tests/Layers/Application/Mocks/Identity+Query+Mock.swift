//
//  MockIdentityQueries.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import UserModule

@testable import UserApplication

actor MockIdentityQueries: Identity.Query.Interface {
    private(set) var searchCallCount = 0
    private(set) var getByCallCount = 0
    private(set) var rolesCallCount = 0
    private(set) var permissionsCallCount = 0

    private let detailResult: Identity.Detail.Output
    private let searchResult: Identity.Search.Output
    private let rolesResult: [String]
    private let permissionsResult: [String]

    init(
        detailResult: Identity.Detail.Output,
        searchResult: Identity.Search.Output,
        rolesResult: [String] = [],
        permissionsResult: [String] = []
    ) {
        self.detailResult = detailResult
        self.searchResult = searchResult
        self.rolesResult = rolesResult
        self.permissionsResult = permissionsResult
    }

    func search(
        query: Identity.Search.Input.Query
    ) async throws -> Identity.Search.Output {
        searchCallCount += 1
        return searchResult
    }

    func getBy(
        id: String
    ) async throws -> Identity.Detail.Output {
        getByCallCount += 1
        return detailResult
    }

    func getRolesBy(
        identityId: String
    ) async throws -> [String] {
        rolesCallCount += 1
        return rolesResult
    }

    func getRoleIdsBy(
        identityId: String
    ) async throws -> [String] {
        []
    }

    func getPermissionsBy(
        identityId: String
    ) async throws -> [String] {
        permissionsCallCount += 1
        return permissionsResult
    }
}
