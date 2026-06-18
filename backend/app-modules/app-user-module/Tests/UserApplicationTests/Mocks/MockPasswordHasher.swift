import Application

actor MockPasswordHasher: PasswordHasher {
    private(set) var hashCallCount = 0
    private(set) var verifyCallCount = 0

    private let hashResult: String
    private let verifyResult: Bool

    init(
        hashResult: String = "hashed-password",
        verifyResult: Bool = true
    ) {
        self.hashResult = hashResult
        self.verifyResult = verifyResult
    }

    func hash(
        _ original: String
    ) async throws -> String {
        hashCallCount += 1
        return hashResult
    }

    func verify(
        _ original: String,
        hash: String
    ) async throws -> Bool {
        verifyCallCount += 1
        return verifyResult
    }
}
