@testable import WebApplication

actor EntryMockQueries: MetadataQueries {
    private(set) var findCallCount = 0
    private(set) var listCallCount = 0
    private(set) var countCallCount = 0
    private(set) var lastFindId: String?
    private(set) var lastListQuery: MetadataList.Query?
    private(set) var lastCountQuery: MetadataList.Query?

    private let findResult: MetadataDetail
    private let listResult: MetadataList
    private let countResult: Int

    init(
        findResult: MetadataDetail,
        listResult: MetadataList,
        countResult: Int
    ) {
        self.findResult = findResult
        self.listResult = listResult
        self.countResult = countResult
    }

    func find(
        id: String
    ) async throws -> MetadataDetail {
        findCallCount += 1
        lastFindId = id
        return findResult
    }

    func list(
        query: MetadataList.Query
    ) async throws -> MetadataList {
        listCallCount += 1
        lastListQuery = query
        return listResult
    }

    func count(
        query: MetadataList.Query
    ) async throws -> Int {
        countCallCount += 1
        lastCountQuery = query
        return countResult
    }
}
