import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactSubmissionsDefaultController:
    AdminRemoveContactSubmissionsController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveContactSubmissionsInteractor,
            presenter: any AdminRemoveContactSubmissionsPresenter
        )
    func bulkConfirm(request: Request, context: DefaultRequestContext)
        async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime(request, context)
        return presenter.renderBulkConfirmation(
            selectedIds: request.queryStrings("selectedIds"),
            permissions: context.currentUserPermissions
        )
    }
    func bulkRemove(request: Request, context: DefaultRequestContext)
        async throws
        -> Response
    {
        let payload = try await request.decode(
            as: ListBulkRemoveFormInput.self,
            context: context
        )
        let (interactor, _) = buildRuntime(request, context)
        try await interactor.bulkRemove(ids: payload.normalizedSelectedIds)
        return Response(
            status: .seeOther,
            headers: [
                .location: ListBulkRemoveRedirect.location(
                    path: "/admin/contact/submissions/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: "Removed",
                    message: "Contact submissions removed successfully."
                )
            ]
        )
    }
}
