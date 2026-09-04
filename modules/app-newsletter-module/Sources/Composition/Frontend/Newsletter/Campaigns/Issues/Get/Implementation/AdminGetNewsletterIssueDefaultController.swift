import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminGetNewsletterIssueDefaultController:
    AdminGetNewsletterIssueController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetNewsletterIssueInteractor,
            presenter: any AdminGetNewsletterIssuePresenter
        )
    func get(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        let issueId = try context.requiredParameter("issueId")
        do {
            return presenter.render(
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
