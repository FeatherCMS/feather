import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterModule
import NewsletterApplication
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.List {
    enum Presenter {}
}

extension Subscriber.List.Presenter {
    protocol Interface: Sendable {
        func render(
            model: Subscriber.List.Model,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse
        func renderDetailsPage(
            item: Subscriber.List.Model.Item,
            permissions: Set<String>
        ) async throws -> HTMLResponse
        func renderDetailsErrorPage(
            message: String,
            status: HTTPResponse.Status
        ) async throws -> HTMLResponse
    }
}
