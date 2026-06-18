@testable import RedirectApplication

actor RuleMockQueries: RuleQueries {
    private(set) var findCallCount = 0
    private(set) var findBySourceCallCount = 0
    private(set) var listCallCount = 0
    private(set) var countCallCount = 0
    private(set) var lastFindId: String?
    private(set) var lastFindSource: String?
    private(set) var lastListQuery: RuleList.Query?
    private(set) var lastCountQuery: RuleList.Query?

    private let findResult: RuleDetail
    private let findBySourceResult: RuleDetail?
    private let listResult: RuleList
    private let countResult: Int

    init(
        findResult: RuleDetail,
        findBySourceResult: RuleDetail? = nil,
        listResult: RuleList,
        countResult: Int
    ) {
        self.findResult = findResult
        self.findBySourceResult = findBySourceResult
        self.listResult = listResult
        self.countResult = countResult
    }

    func find(
        id: String
    ) async throws -> RuleDetail {
        findCallCount += 1
        lastFindId = id
        return findResult
    }

    func find(
        source: String
    ) async throws -> RuleDetail? {
        findBySourceCallCount += 1
        lastFindSource = source
        return findBySourceResult
    }

    func list(
        query: RuleList.Query
    ) async throws -> RuleList {
        listCallCount += 1
        lastListQuery = query
        return listResult
    }

    func count(
        query: RuleList.Query
    ) async throws -> Int {
        countCallCount += 1
        lastCountQuery = query
        return countResult
    }
}
