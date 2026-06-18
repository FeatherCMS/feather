import Hummingbird

protocol AdminEditMediaAssetPresenter: Sendable {
    func renderEditPage(
        model: AdminEditMediaAssetModel,
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
