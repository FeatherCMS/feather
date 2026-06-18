import Hummingbird

protocol AdminAddMediaProcessorPresenter: Sendable {
    func renderPage(
        model: AdminAddMediaProcessorModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
