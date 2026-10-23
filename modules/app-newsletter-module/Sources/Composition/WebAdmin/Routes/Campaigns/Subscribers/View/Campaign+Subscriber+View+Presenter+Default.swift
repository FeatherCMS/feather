import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Campaign.Subscriber.View.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Campaign.Router.Routes

        func render(
            newsletterId: String,
            item: Campaign.Subscriber.Item
        ) async throws -> HTMLResponse {
            let content = Campaign.Subscriber.FormView(
                state: .init(
                    newsletterId: newsletterId,
                    email: item.email,
                    firstName: item.firstName,
                    lastName: item.lastName,
                    status: item.status,
                    isEdit: true,
                    error: nil,
                    editAction: routes.subscriberEditPath(
                        newsletterId: newsletterId,
                        subscriberId: item.id
                    ),
                    pageHeader: .primary(
                        title: "Campaign subscriber",
                        description: "Review this campaign subscription."
                    ),
                    routes: routes
                )
            )
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Campaign subscriber",
                content: content
            )
        }
    }
}
