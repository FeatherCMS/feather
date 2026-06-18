import Hummingbird

protocol AdminRemoveMediaAssetPresenter: Sendable {

    func renderPage(
        model: AdminRemoveMediaAssetModel,
        permissions: Set<String>
    ) -> HTMLResponse

}
