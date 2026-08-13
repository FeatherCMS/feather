import FeatherAdmin
import Foundation

protocol AdminGetAnalyticsNotFoundPresenter: Sendable {

    func render(
        model: AdminGetAnalyticsNotFoundModel,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderDenied(
        permissions: Set<String>
    ) -> HTMLResponse

    func renderError(
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse
}
