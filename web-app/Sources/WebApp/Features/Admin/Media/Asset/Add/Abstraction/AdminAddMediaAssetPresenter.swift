import Hummingbird

protocol AdminAddMediaAssetPresenter: Sendable {
    func renderPage(
        model: AdminAddMediaAssetModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
