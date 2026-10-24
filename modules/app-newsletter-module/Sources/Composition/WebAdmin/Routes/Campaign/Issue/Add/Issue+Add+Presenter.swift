import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Issue.Add {
    enum Presenter {}
}

extension Issue.Add.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            model: Issue.Form.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
