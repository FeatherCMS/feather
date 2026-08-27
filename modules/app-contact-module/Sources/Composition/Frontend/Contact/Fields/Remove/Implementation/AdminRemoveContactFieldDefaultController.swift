import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactFieldDefaultController:
    AdminRemoveContactFieldController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveContactFieldInteractor,
            presenter: any AdminRemoveContactFieldPresenter
        )

    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredParameter("fieldId")
        let field = try? await interactor.get(id: id)
        return presenter.renderConfirmation(
            fieldId: id,
            label: field?.label ?? id,
            permissions: context.currentUserPermissions
        )
    }

    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        try await interactor.remove(
            id: try context.requiredParameter("fieldId")
        )
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/contact/fields/",
                    title: "Removed",
                    message: "Contact field removed successfully."
                )
            ]
        )
    }

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
                    path: "/admin/contact/fields/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: "Removed",
                    message: "Contact fields removed successfully."
                )
            ]
        )
    }

}
