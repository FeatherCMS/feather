import FeatherWebAdmin

protocol AdminListAccountInvitationPresenter: Sendable {

    func renderListPage(
        model: AdminListAccountInvitationModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse
}
