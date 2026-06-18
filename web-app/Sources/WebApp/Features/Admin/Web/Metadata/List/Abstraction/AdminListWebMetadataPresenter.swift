import Hummingbird

protocol AdminListWebMetadataPresenter: Sendable {

    func renderListPage(
        model: AdminListWebMetadataModel,
        isEdited: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) -> HTMLResponse
}
