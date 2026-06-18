import AuthDomain

actor MockSessionRepository: SessionRepository {
    private(set) var findByTokenCallCount = 0
    private(set) var updateCallCount = 0
    private(set) var deleteCallCount = 0

    private let tokenFindResult: Session?
    private let deleteResult: Bool

    init(
        tokenFindResult: Session? = nil,
        deleteResult: Bool = false
    ) {
        self.tokenFindResult = tokenFindResult
        self.deleteResult = deleteResult
    }

    func findBy(
        id: String
    ) async throws -> Session? {
        nil
    }

    func findBy(
        token: String
    ) async throws -> Session? {
        findByTokenCallCount += 1
        return tokenFindResult
    }

    func insert(
        _ model: Session.New
    ) async throws -> Session {
        fatalError("not needed in tests")
    }

    func update(
        _ model: Session
    ) async throws -> Session {
        updateCallCount += 1
        return model
    }

    func delete(
        id: String
    ) async throws -> Bool {
        deleteCallCount += 1
        return deleteResult
    }
}
