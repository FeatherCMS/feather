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

extension Subscriber.Remove {
    enum Presenter {}
}

extension Subscriber.Remove.Presenter {
    protocol Interface: Sendable {
        func renderRemovePage(
            items: [AdminRemoveItemContext],
            search: String?,
            campaignId: String?,
            returnTo: String?
        ) async throws -> HTMLResponse
    }
}
