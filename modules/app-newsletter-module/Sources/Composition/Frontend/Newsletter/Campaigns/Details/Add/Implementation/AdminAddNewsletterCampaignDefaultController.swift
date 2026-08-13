import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddNewsletterCampaignDefaultController:
    AdminAddNewsletterCampaignController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddNewsletterCampaignInteractor,
            presenter: any AdminAddNewsletterCampaignPresenter
        )

    func getAddNewsletterCampaign(request: Request, context: AppRequestContext)
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        return presenter.renderPage(
            model: try await interactor.getAddNewsletterCampaign(),
            permissions: context.currentUserPermissions
        )
    }

    func postAddNewsletterCampaign(request: Request, context: AppRequestContext)
        async throws -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: NewsletterCampaignAddForm.self,
            context: context
        )
        let model = try await interactor.postAddNewsletterCampaign(
            payload: payload
        )
        if model.error == nil {
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/newsletters/",
                        title: "Added",
                        message: "Campaign added successfully."
                    )
                ]
            )
        }
        return
            try presenter.renderPage(
                model: model,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }
}
