import FeatherAdmin
import Hummingbird

protocol AppPublicContentPresenter: Sendable {

    func render(
        content: AppPublicResolvedContent,
        request: Request
    ) async -> HTMLResponse
}
