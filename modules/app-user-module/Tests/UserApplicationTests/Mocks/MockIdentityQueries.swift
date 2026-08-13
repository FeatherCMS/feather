//
//  MockIdentityQueries.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

@testable import UserApplication

actor MockIdentityQueries: IdentityQueries {
    private(set) var listCallCount = 0
    private(set) var countCallCount = 0
    private(set) var getByCallCount = 0
    private(set) var rolesCallCount = 0
    private(set) var permissionsCallCount = 0

    private let detailResult: IdentityDetail
    private let listResult: IdentityList
    private let countResult: Int
    private let rolesResult: [String]
    private let permissionsResult: [String]

    init(
        detailResult: IdentityDetail,
        listResult: IdentityList,
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
        query: IdentityList.Query
    ) async throws -> IdentityList {
        listCallCount += 1
        return listResult
    }

    func count(
        query: IdentityList.Query
    ) async throws -> Int {
        countCallCount += 1
        return countResult
    }

    func getBy(
        id: String
    ) async throws -> IdentityDetail {
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
