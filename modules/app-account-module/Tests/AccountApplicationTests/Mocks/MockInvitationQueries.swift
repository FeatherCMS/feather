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

    init(
        listResult: InvitationList,
        countResult: Int
    ) {
        self.listResult = listResult
        self.countResult = countResult
    }

    func getBy(
        id: String
    ) async throws -> InvitationDetail {
        fatalError("not needed in tests")
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
