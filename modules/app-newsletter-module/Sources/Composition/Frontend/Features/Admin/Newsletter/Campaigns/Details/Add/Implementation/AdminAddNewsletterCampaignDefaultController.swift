import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterCampaignDefaultController:
    AdminAddNewsletterCampaignController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminAddNewsletterCampaignInteractor,
            presenter: any AdminAddNewsletterCampaignPresenter
        )

    func getAddNewsletterCampaign(
        request: Request,
        context: DefaultRequestContext
    )
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
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
        context: DefaultRequestContext
    )
        async throws -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
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
