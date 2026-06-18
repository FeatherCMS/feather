import Domain

public protocol MagicLinkRepository: Repository {

    func findById(
        id: String
    ) async throws -> MagicLink?

    func insert(
        _ model: MagicLink.New
    ) async throws -> MagicLink

    func update(
        _ model: MagicLink
    ) async throws -> MagicLink

    func consumeByToken(
        token: String,
        now: Double
    ) async throws -> MagicLink

    func delete(
        id: String
    ) async throws -> Bool
}
