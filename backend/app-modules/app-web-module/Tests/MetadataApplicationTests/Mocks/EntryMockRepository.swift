import WebDomain

actor EntryMockRepository: MetadataRepository {

    private(set) var lastCreateInput: Metadata.New?
    private(set) var createCallCount = 0
    private(set) var updateCallCount = 0
    private(set) var findCallCount = 0
    private(set) var deleteCallCount = 0
    private(set) var lastFindId: String?
    private(set) var lastFindSource: String?
    private(set) var lastDeleteId: String?

    private let result: Result<Metadata, Error>
    private let findResult: Metadata?
    private let deleteResult: Bool

    init(
        result: Result<Metadata, Error>,
        findResult: Metadata? = nil,
        deleteResult: Bool = false
    ) {
        self.result = result
        self.findResult = findResult
        self.deleteResult = deleteResult
    }

    func insert(
        _ model: Metadata.New
    ) async throws -> Metadata {
        createCallCount += 1
        lastCreateInput = model
        return try result.get()
    }

    func update(
        _ model: Metadata
    ) async throws -> Metadata {
        updateCallCount += 1
        return model
    }

    func find(
        id: String
    ) async throws -> Metadata? {
        findCallCount += 1
        lastFindId = id
        return findResult
    }

    func find(
        source: String
    ) async throws -> Metadata? {
        findCallCount += 1
        lastFindSource = source
        return findResult
    }

    func delete(
        id: String
    ) async throws -> Bool {
        deleteCallCount += 1
        lastDeleteId = id
        return deleteResult
    }
}
