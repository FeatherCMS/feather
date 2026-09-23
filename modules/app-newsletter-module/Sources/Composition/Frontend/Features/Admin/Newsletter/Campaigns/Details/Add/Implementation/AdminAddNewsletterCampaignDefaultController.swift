import FeatherAdmin
import Hummingbird
import NewsletterContracts

struct AdminAddNewsletterCampaignDefaultController:
    AdminAddNewsletterCampaignController
{
    let buildRuntime: RuntimeBuilder<
        any AdminAddNewsletterCampaignInteractor,
        any AdminAddNewsletterCampaignPresenter
    >

    func getAddNewsletterCampaign(
        request: Request,
        context: DefaultRequestContext
    )
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: Permissions.Campaigns.create)
        else {
            return try await presenter.renderPage(
                model: .init(
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
        context: DefaultRequestContext
    )
        async throws -> Response
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: Permissions.Campaigns.create)
        else {
            return
                try await presenter.renderPage(
                    model: .init(
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
        let model = try await interactor.postAddNewsletterCampaign(
            payload: payload
        )
        if model.error == nil {
            return AdminNotificationFlash.redirect(
                to: NewsletterAdminRoutes.campaigns.description,
                notification: .init(
                    title: "Added",
                    message: "Campaign added successfully."
                )
            )
        }
        return
            try await presenter.renderPage(
                model: model,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }
}
