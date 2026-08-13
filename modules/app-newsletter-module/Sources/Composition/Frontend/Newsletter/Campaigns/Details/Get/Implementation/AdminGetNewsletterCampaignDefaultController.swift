import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminGetNewsletterCampaignDefaultController:
    AdminGetNewsletterCampaignController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetNewsletterCampaignInteractor,
            presenter: any AdminGetNewsletterCampaignPresenter
        )
    func get(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredParameter("newsletterId")
        do {
            return presenter.render(
                item: try await interactor.get(id: id),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.render(
                item: .init(id: id, name: "", fromEmail: ""),
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
}
