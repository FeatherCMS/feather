//
//  MockInvitationQueries.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AccountDomain
import AccountModule

@testable import AccountApplication
@testable import UserApplication

actor MockInvitationQueries: Invitation.Detail.Query.Interface,
    Invitation.List.Query.Interface,
    Invitation.Search.Query.Interface
{
    private(set) var listCallCount = 0
    private(set) var searchCallCount = 0

    private let listResult: Invitation.List.Output
    private let searchResult: Invitation.Search.Output
    private let tokenResult: Invitation.Detail.Output?

    init(
        listResult: Invitation.List.Output,
        searchResult: Invitation.Search.Output = .init(items: [], total: 0),
        tokenResult: Invitation.Detail.Output? = nil
    ) {
        self.listResult = listResult
        self.searchResult = searchResult
        self.tokenResult = tokenResult
    }

    func getBy(
        id: String
    ) async throws -> Invitation.Detail.Output {
        fatalError("not needed in tests")
    }

    func getBy(
        token: String
    ) async throws -> Invitation.Detail.Output {
        guard let tokenResult else { fatalError("not needed in tests") }
        return tokenResult
    }

    func list() async throws -> Invitation.List.Output {
        listCallCount += 1
        return listResult
    }

    func search(
        query: Invitation.Search.Input.Query
    ) async throws -> Invitation.Search.Output {
        searchCallCount += 1
        return searchResult
    }
}
