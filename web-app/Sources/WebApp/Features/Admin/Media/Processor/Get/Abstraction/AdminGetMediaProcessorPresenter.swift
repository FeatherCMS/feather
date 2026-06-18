import Hummingbird

protocol AdminGetMediaProcessorPresenter: Sendable {

    func renderPage(
        model: AdminGetMediaProcessorModel?,
        id: String,
        permissions: Set<String>,
        error: String?
    ) -> HTMLResponse
}
