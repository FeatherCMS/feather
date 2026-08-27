//
//  MockInvitationQueries.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AccountDomain

@testable import AccountApplication
@testable import UserApplication

actor MockInvitationQueries: InvitationQueries {
    private(set) var listCallCount = 0
    private(set) var countCallCount = 0

    private let listResult: InvitationList
    private let countResult: Int
    private let tokenResult: InvitationDetail?

    init(
        listResult: InvitationList,
        countResult: Int,
        tokenResult: InvitationDetail? = nil
    ) {
        self.listResult = listResult
        self.countResult = countResult
        self.tokenResult = tokenResult
    }

    func getBy(
        id: String
    ) async throws -> InvitationDetail {
        fatalError("not needed in tests")
    }

    func getBy(
        token: String
    ) async throws -> InvitationDetail {
        guard let tokenResult else { fatalError("not needed in tests") }
        return tokenResult
    }

    func list(
        query: InvitationList.Query
    ) async throws -> InvitationList {
        listCallCount += 1
        return listResult
    }

    func count(
        query: InvitationList.Query
    ) async throws -> Int {
        countCallCount += 1
        return countResult
    }
}
