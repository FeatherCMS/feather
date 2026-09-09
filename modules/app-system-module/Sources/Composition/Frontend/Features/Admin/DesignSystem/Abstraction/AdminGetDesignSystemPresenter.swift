import FeatherAdmin
import Hummingbird

protocol AdminGetDesignSystemPresenter: Sendable {

    func renderPage(
        model: AdminGetDesignSystemModel
    ) async throws -> HTMLResponse
}
