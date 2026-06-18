protocol AdminEditMediaFolderInteractor: Sendable {
    func load(
        id: String
    ) async throws -> AdminEditMediaFolderModel
    func update(
        id: String,
        input: MediaFolderEditForm
    ) async throws
        -> AdminEditMediaFolderModel
}
