import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterCampaignDefaultController:
    AdminViewNewsletterCampaignController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminViewNewsletterCampaignInteractor,
            any AdminViewNewsletterCampaignPresenter
        >
    func get(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter
        let id = try context.requiredParameter("newsletterId")
        guard context.isCurrentUserAllowed(to: Campaign.Permissions.read)
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
