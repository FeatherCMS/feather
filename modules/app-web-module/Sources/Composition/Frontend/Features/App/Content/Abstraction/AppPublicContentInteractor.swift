protocol AppPublicContentInteractor: Sendable {

    func resolve(
        slug: String
    ) async throws -> AppPublicContentModel
}
