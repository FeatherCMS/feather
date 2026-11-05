import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Issue.Search {
    enum Presenter {
        protocol Interface: Sendable {
            func render(
                newsletterId: String,
                model: AdminListModel<Item>,
                error: String?,
                permissions: AdminListActions,
                search: String?
            ) async throws -> HTMLResponse
        }
    }
}
