import Hummingbird

protocol AdminGetMediaAssetPresenter: Sendable {

    func renderPage(
        model: AdminGetMediaAssetModel?,
        id: String,
        permissions: Set<String>,
        error: String?
    ) -> HTMLResponse
}
