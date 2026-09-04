import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminListNewsletterIssuesDefaultController:
    AdminListNewsletterIssuesController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListNewsletterIssuesInteractor,
            presenter: any AdminListNewsletterIssuesPresenter
        )

    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        do {
            return presenter.render(
                newsletterId: newsletterId,
                items: try await interactor.list(newsletterId: newsletterId),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.render(
                newsletterId: newsletterId,
                items: [],
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
}
