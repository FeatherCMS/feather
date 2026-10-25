import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Campaign.Subscriber.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Campaign.Router.Routes

        func render(
            newsletterId: String,
            form: Campaign.Subscriber.Form.Input,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            let content = Campaign.Subscriber.Form.Component(
                state: .init(
                    newsletterId: newsletterId,
                    email: form.email,
                    firstName: form.firstName,
                    lastName: form.lastName,
                    status: form.status,
                    isEdit: false,
                    error: error,
                    editAction: nil,
                    pageHeader: .primary(
                        title: "Edit newsletter campaign",
                        description:
                            "Update the newsletter campaign settings."
                    ),
                    routes: routes
                )
            )
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Add campaign subscriber",
                content: content
            )
        }
    }
}
