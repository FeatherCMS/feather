import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveNewsletterSubscribersDefaultController:
    AdminRemoveNewsletterSubscribersController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveNewsletterSubscribersInteractor,
            presenter: any AdminRemoveNewsletterSubscribersPresenter
        )

    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime(request, context)
        return presenter.render(
            ids: request.queryStrings("selectedIds"),
            search: request.querySearch(),
            campaignId: request.queryString("campaignId"),
            permissions: context.currentUserPermissions
        )
    }

    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: ListBulkRemoveFormInput.self,
            context: context
        )
        try await interactor.remove(
            ids: payload.normalizedSelectedIds,
            campaignId: payload.campaignId?.emptyToNil
        )
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/newsletters/subscribers/",
                    title: "Removed",
                    message: "Selected subscribers removed successfully."
                )
            ]
        )
    }
}
