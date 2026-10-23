import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Issue.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Campaign.Router.Routes

        func renderPage(
            model: Issue.Form.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Add campaign issue",
                content: NewsletterIssueAddView(
                    state: .init(
                        subject: model.subject,
                        content: model.content,
                        scheduledAt: model.scheduledAt,
                        newsletterId: model.newsletterId,
                        issueId: nil,
                        error: model.error,
                        pageHeader: .primary(
                            title: "Add campaign issue",
                            description:
                                "Compose the issue content and delivery schedule."
                        ),
                        routes: routes
                    )
                )
            )
        }
    }
}
