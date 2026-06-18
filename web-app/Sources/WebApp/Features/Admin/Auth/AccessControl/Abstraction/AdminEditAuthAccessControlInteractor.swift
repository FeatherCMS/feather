protocol AdminEditAuthAccessControlInteractor: Sendable {

    func loadState(
        isEdited: Bool,
        canEdit: Bool,
        selectedOverride: Set<String>?,
        error: String?
    ) async throws -> AdminEditAuthAccessControlState

    func save(
        input: AdminEditAuthAccessControlFormInput
    ) async throws -> AdminEditAuthAccessControlSaveResult
}
