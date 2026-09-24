import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterCampaignDefaultController:
    AdminViewNewsletterCampaignController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewNewsletterCampaignInteractor,
            any AdminViewNewsletterCampaignPresenter
        >
    func get(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        let id = try request.requiredParameter("newsletterId")
        guard context.isCurrentUserAllowed(to: Permissions.Campaigns.read)
        else {
            return try await presenter.render(
                item: .init(id: id, name: "", fromEmail: ""),
                error: "Your account cannot view newsletter campaigns.",
                permissions: context.currentUserPermissions
            )
        }
        do {
            return try await presenter.render(
                item: try await interactor.get(id: id),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return try await presenter.render(
                item: .init(id: id, name: "", fromEmail: ""),
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
}
