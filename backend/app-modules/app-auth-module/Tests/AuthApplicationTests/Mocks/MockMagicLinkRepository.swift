import AuthDomain

actor MockMagicLinkRepository: MagicLinkRepository {
    private(set) var insertCallCount = 0
    private(set) var deleteCallCount = 0

    private let result: MagicLink
    private let deleteResult: Bool

    init(
        result: MagicLink,
        deleteResult: Bool = false
    ) {
        self.result = result
        self.deleteResult = deleteResult
    }

    func findById(
        id: String
    ) async throws -> MagicLink? {
        nil
    }

    func insert(
        _ model: MagicLink.New
    ) async throws -> MagicLink {
        insertCallCount += 1
        return result
    }

    func update(
        _ model: MagicLink
    ) async throws -> MagicLink {
        model
    }

    func consumeByToken(
        token: String,
        now: Double
    ) async throws -> MagicLink {
        result
    }

    func delete(
        id: String
    ) async throws -> Bool {
        deleteCallCount += 1
        return deleteResult
    }
}
