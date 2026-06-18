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
