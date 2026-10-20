//
//  MockRoleQueries.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import UserModule

@testable import UserApplication

actor MockRoleQueries: Role.Query.Interface {
    private(set) var searchCallCount = 0

    private let detailResult: Role.Detail.Output
    private let searchResult: Role.Search.Output

    init(
        detailResult: Role.Detail.Output,
        searchResult: Role.Search.Output
    ) {
        self.detailResult = detailResult
        self.searchResult = searchResult
    }

    func search(
        query: Role.Search.Input.Query
    ) async throws -> Role.Search.Output {
        searchCallCount += 1
        return searchResult
    }

    func getBy(
        id: String
    ) async throws -> Role.Detail.Output {
        detailResult
    }
}
