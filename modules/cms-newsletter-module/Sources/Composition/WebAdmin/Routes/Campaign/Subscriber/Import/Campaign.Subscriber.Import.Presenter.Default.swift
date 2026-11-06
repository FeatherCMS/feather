import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Campaign.Subscriber.Import.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Campaign.Router.Routes

        func render(
            newsletterId: String,
            error: String?
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Import campaign subscribers",
                content: Campaign.Subscriber.Import.View(
                    state: .init(
                        newsletterId: newsletterId,
                        error: error,
                        routes: routes
                    )
                )
            )
        }
    }
}
