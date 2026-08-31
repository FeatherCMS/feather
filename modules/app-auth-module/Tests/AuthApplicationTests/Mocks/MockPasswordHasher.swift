import FeatherDomain

struct MockPasswordHasher: PasswordHasher {
    func hash(
        _ original: String
    ) async throws -> String {
        "hashed-\(original)"
    }

    func verify(
        _ original: String,
        hash: String
    ) async throws -> Bool {
        hash == "hashed-\(original)"
    }
}
