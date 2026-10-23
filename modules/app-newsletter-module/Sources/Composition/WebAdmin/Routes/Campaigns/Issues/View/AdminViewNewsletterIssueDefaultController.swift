import FeatherWebAdmin
import FeatherWebShared
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterIssueDefaultController:
    AdminViewNewsletterIssueController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminViewNewsletterIssueInteractor,
            any AdminViewNewsletterIssuePresenter
        >
    func get(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter
        let newsletterId = try context.requiredParameter("newsletterId")
        let issueId = try context.requiredParameter("issueId")
        do {
            return try await presenter.render(
                model: try await interactor.get(
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
