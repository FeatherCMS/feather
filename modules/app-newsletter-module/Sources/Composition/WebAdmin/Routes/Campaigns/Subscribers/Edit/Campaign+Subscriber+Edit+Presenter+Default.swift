import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Campaign.Subscriber.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Campaign.Router.Routes

        func render(
            newsletterId: String,
            subscriberId: String,
            form: Campaign.Subscriber.Form,
            error: String?
        ) async throws -> HTMLResponse {
            let content = Campaign.Subscriber.FormView(
                state: .init(
                    newsletterId: newsletterId,
                    email: form.email,
                    firstName: form.firstName,
                    lastName: form.lastName,
                    status: form.status,
                    isEdit: true,
                    error: error,
                    editAction: routes.subscriberEditPath(
                        newsletterId: newsletterId,
                        subscriberId: subscriberId
                    ),
                    pageHeader: .primary(
                        title: "Edit campaign subscriber",
                        description: "Manage this campaign subscription."
                    ),
                    routes: routes
                )
            )
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit campaign subscriber",
                content: content
            )
        }
    }
}
