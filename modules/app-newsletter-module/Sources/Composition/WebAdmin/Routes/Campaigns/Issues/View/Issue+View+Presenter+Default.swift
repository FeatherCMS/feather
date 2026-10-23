import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Issue.View.Presenter {
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
                title: "Campaign issue details",
                content: NewsletterIssueDetailsView(
                    newsletterId: model.newsletterId,
                    issueId: issueId,
                    model: model,
                    permissions: AdminListActions(
                        Set(permissions.map(PermissionKey.init))
                    ),
                    routes: routes
                )
            )
        }
    }
}
