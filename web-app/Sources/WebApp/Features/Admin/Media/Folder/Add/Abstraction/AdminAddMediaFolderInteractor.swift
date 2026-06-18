protocol AdminAddMediaFolderInteractor: Sendable {
    func getAddMediaFolder(
        parentId: String?,
        view: String
    ) async throws
        -> AdminAddMediaFolderModel
    func postAddMediaFolder(
        payload: MediaFolderAddForm
    ) async throws
        -> AdminAddMediaFolderModel
}
