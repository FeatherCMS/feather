import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Issue.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Campaign.Router.Routes

        func renderPage(
            model: Issue.Form.Model,
            issueId: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit campaign issue",
                content: Issue.Form.View(
                    state: .init(
                        subject: model.subject,
                        content: model.content,
                        newsletterId: model.newsletterId,
                        issueId: issueId,
                        error: model.error,
                        pageHeader: .primary(
                            title: "Edit campaign",
                            description:
                                "Update the campaign settings."
                        ),
                        routes: routes
                    )
                )
            )
        }
    }
}
