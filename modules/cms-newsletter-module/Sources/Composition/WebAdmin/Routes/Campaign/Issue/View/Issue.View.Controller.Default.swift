import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule

extension Issue.View.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Issue.View.Interactor.Interface,
                any Issue.View.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let newsletterId = try context.requiredParameter("newsletterId")
            let issueId = try context.requiredParameter("issueId")

            do {
                return try await runtime.presenter.renderPage(
                    model: try await runtime.interactor.get(
                        newsletterId: newsletterId,
                        issueId: issueId
                    ),
                    issueId: issueId,
                    permissions: context.currentUserPermissions
                )
            }
            catch {
                return HTMLResponse(
                    content: error.displayMessage,
                    status: .notFound
                )
            }
        }
    }
}
