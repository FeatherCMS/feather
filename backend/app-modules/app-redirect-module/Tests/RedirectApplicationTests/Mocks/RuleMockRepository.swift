import RedirectDomain

actor RuleMockRepository: RuleRepository {

    private(set) var lastCreateInput: Rule.New?
    private(set) var createCallCount = 0
    private(set) var updateCallCount = 0
    private(set) var findCallCount = 0
    private(set) var deleteCallCount = 0
    private(set) var lastFindId: String?
    private(set) var lastFindSource: String?
    private(set) var lastDeleteId: String?

    private let result: Result<Rule, Error>
    private let findResult: Rule?
    private let deleteResult: Bool

    init(
        result: Result<Rule, Error>,
        findResult: Rule? = nil,
        deleteResult: Bool = false
    ) {
        self.result = result
        self.findResult = findResult
        self.deleteResult = deleteResult
    }

    func insert(
        _ model: Rule.New
    ) async throws -> Rule {
        createCallCount += 1
        lastCreateInput = model
        return try result.get()
    }

    func update(
        _ model: Rule
    ) async throws -> Rule {
        updateCallCount += 1
        return model
    }

    func find(
        id: String
    ) async throws -> Rule? {
        findCallCount += 1
        lastFindId = id
        return findResult
    }

    func find(
        source: String
    ) async throws -> Rule? {
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
