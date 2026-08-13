import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListNewsletterCampaignSubscribersDefaultController:
    AdminListNewsletterCampaignSubscribersController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListNewsletterCampaignSubscribersInteractor,
            presenter: any AdminListNewsletterCampaignSubscribersPresenter
        )
    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        let search = request.querySearch()
        do {
            return presenter.render(
                newsletterId: newsletterId,
                items: try await interactor.list(
                    newsletterId: newsletterId,
                    search: search
                ),
                search: search,
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.render(
                newsletterId: newsletterId,
                items: [],
                search: search,
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
}
