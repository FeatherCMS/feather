import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

struct AdminAddNewsletterCampaignDefaultController:
    AdminAddNewsletterCampaignController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminAddNewsletterCampaignInteractor,
            any AdminAddNewsletterCampaignPresenter
        >

    func getAddNewsletterCampaign(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> HTMLResponse
    {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter
        guard context.isCurrentUserAllowed(to: Campaign.Permissions.create)
        else {
            return try await presenter.renderPage(
                model: .init(
                    key: "",
                    name: "",
                    fromEmail: "",
                    error: "Your account cannot create newsletter campaigns."
                ),
                permissions: context.currentUserPermissions
            )
        }
        return try await presenter.renderPage(
            model: try await interactor.getAddNewsletterCampaign(),
            permissions: context.currentUserPermissions
        )
    }

    func postAddNewsletterCampaign(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> Response
    {
        let __runtimeBuild2 = buildRuntime(request, context)
        let interactor = __runtimeBuild2.interactor
        let presenter = __runtimeBuild2.presenter
        guard context.isCurrentUserAllowed(to: Campaign.Permissions.create)
        else {
            return
                try await presenter.renderPage(
                    model: .init(
                        key: "",
                        name: "",
                        fromEmail: "",
                        error:
                            "Your account cannot create newsletter campaigns."
                    ),
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
        let payload = try await request.decode(
            as: NewsletterCampaignAddForm.self,
            context: context
        )
        do {
            _ = try await interactor.postAddNewsletterCampaign(
                payload: payload
            )
            return AdminNotificationFlash.redirect(
                to: NewsletterAdminRoutes.campaigns.description,
                notification: .init(
                    title: "Added",
                    message: "Campaign added successfully."
                )
            )
        }
        catch let error as AdminAddNewsletterCampaignError {
            return
                try await presenter.renderAddError(
                    input: payload,
                    error: error,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
