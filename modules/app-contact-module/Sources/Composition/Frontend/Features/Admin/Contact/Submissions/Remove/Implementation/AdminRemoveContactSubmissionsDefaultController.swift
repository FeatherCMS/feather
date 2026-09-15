import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactSubmissionsDefaultController:
    AdminRemoveContactSubmissionsController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveContactSubmissionsInteractor,
            presenter: any AdminRemoveContactSubmissionsPresenter
        )
    func confirm(request: Request, context: DefaultRequestContext)
        async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime(request, context)
        return try await presenter.renderRemovePage(
            items: request.queryStrings("selectedIds").map {
                .init(id: $0, label: $0)
            }
        )
    }
    func remove(request: Request, context: DefaultRequestContext)
        async throws
        -> Response
    {
        let payload = try await request.decode(
            as: NewAdminListRemoveFormInput.self,
            context: context
        )
        guard await AdminNonceStore.shared.consume(
            payload.nonce,
            sessionToken: context.sessionToken
        ) else { return Response(status: .badRequest) }
        let (interactor, _) = buildRuntime(request, context)
        try await interactor.remove(ids: payload.normalizedSelectedIds)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminListRemoveRedirect.location(
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
