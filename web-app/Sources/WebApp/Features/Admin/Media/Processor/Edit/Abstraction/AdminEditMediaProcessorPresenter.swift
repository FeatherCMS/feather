import Hummingbird

protocol AdminEditMediaProcessorPresenter: Sendable {

    func renderPage(
        model: AdminEditMediaProcessorModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
