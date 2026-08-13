import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveNewsletterCampaignDefaultController:
    AdminRemoveNewsletterCampaignController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminRemoveNewsletterCampaignInteractor,
            presenter: any AdminRemoveNewsletterCampaignPresenter
        )
    func confirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime(request, context)
        return presenter.render(
            id: try context.requiredParameter("newsletterId"),
            permissions: context.currentUserPermissions
        )
    }
    func remove(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        try await interactor.remove(
            id: try context.requiredParameter("newsletterId")
        )
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/newsletters/",
                    title: "Removed",
                    message: "Campaign removed successfully."
                )
            ]
        )
    }
    func removeSelected(request: Request, context: AppRequestContext)
        async throws -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: ListBulkRemoveFormInput.self,
            context: context
        )
        try await interactor.remove(ids: payload.normalizedSelectedIds)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/newsletters/",
                    title: "Removed",
                    message: "Campaigns removed successfully."
                )
            ]
        )
    }
}
