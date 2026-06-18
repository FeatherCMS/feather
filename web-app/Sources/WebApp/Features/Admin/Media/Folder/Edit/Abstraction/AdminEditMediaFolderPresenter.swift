import Hummingbird

protocol AdminEditMediaFolderPresenter: Sendable {

    func renderEditPage(
        model: AdminEditMediaFolderModel,
        isEdited: Bool,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse
}
