import Hummingbird

protocol AdminRemoveMediaProcessorPresenter: Sendable {

    func renderPage(
        model: AdminRemoveMediaProcessorModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
