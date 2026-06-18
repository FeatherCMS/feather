import Hummingbird

protocol AppPublicContentPresenter: Sendable {
    func render(
        content: AppPublicResolvedContent,
        request: Request
    ) -> HTMLResponse
}
