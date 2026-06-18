public protocol PasswordHasher: Sendable {
    func hash(
        _ original: String
    ) async throws -> String
    func verify(
        _ original: String,
        hash: String
    ) async throws -> Bool
}
