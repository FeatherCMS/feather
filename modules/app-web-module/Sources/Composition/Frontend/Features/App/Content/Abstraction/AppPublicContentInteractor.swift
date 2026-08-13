protocol AppPublicContentInteractor: Sendable {
    func resolve(
        path: String
    ) async throws -> AppPublicResolvedContent?
}
