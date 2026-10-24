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

extension Subscriber.Add {
    enum Presenter {}
}

extension Subscriber.Add.Presenter {
    protocol Interface: Sendable {
        func render(
            model: Subscriber.Add.Model,
            isAdded: Bool,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
