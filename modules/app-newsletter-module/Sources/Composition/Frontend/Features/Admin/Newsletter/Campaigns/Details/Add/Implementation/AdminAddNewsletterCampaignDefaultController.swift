import FeatherAdmin
import Hummingbird
import NewsletterContracts

struct AdminAddNewsletterCampaignDefaultController:
    AdminAddNewsletterCampaignController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminAddNewsletterCampaignInteractor,
            any AdminAddNewsletterCampaignPresenter
        >

    func getAddNewsletterCampaign(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: Permissions.Campaigns.create)
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
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: Permissions.Campaigns.create)
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
            return try await presenter.renderAddError(
                input: payload,
                error: error,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
        }
    }
}
