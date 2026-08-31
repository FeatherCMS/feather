protocol AdminEditAccountProfileRepository: Sendable {
    func load(userID: String) async throws -> AdminEditAccountProfileModel
    func save(
        userID: String,
        input: AdminEditAccountProfileFormInput
    ) async throws
}
