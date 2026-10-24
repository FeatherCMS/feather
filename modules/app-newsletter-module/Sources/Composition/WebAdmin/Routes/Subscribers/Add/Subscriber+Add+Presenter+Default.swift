import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Subscriber.Router.Routes

        func render(
            model: Subscriber.Add.Model,
            isAdded: Bool,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Add subscriber",
                content: Subscriber.Add.View(
                    model: model,
                    isAdded: isAdded,
                    routes: routes
                )
            )
        }
    }
}
