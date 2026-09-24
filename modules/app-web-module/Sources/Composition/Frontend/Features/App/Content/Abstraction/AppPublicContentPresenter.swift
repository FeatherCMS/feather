import FeatherAdmin
import Hummingbird

protocol AppPublicContentPresenter: Sendable {

    func render(
        content: AppPublicContentModel
    ) async -> HTMLResponse
}
