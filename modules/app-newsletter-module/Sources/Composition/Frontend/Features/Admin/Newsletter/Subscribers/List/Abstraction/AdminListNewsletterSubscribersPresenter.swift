import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListNewsletterSubscribersPresenter: Sendable {
    func render(
        model: AdminNewsletterSubscribersListModel,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse
    func renderDetailsPage(
        item: AdminNewsletterSubscriberListItem,
        permissions: Set<String>
    ) async throws -> HTMLResponse
    func renderDetailsErrorPage(
        message: String,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse
}
