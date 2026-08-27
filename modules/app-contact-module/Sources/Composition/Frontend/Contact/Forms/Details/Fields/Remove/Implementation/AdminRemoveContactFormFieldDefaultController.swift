import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactFormFieldDefaultController:
    AdminRemoveContactFormFieldController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveContactFormFieldInteractor,
            presenter: any AdminRemoveContactFormFieldPresenter
        )
    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = context.parameters.get("formId", as: String.self) ?? ""
        let id = try context.requiredParameter("fieldId")
        let field = try? await interactor.get(formId: formId, id: id)
        return presenter.renderConfirmation(
            formId: formId,
            fieldId: id,
            label: field?.label ?? id,
            permissions: context.currentUserPermissions
        )
    }
    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let formId = context.parameters.get("formId", as: String.self) ?? ""
        try await interactor.remove(
            formId: formId,
            id: try context.requiredParameter("fieldId")
        )
        let basePath = "/admin/contact/forms/\(formId)/fields/"
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: basePath,
                    title: "Removed",
                    message: "Contact form field removed successfully."
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
            formId: try context.requiredParameter("formId"),
            selectedIds: request.queryStrings("selectedIds"),
            permissions: context.currentUserPermissions
        )
    }
    func bulkRemove(request: Request, context: DefaultRequestContext)
        async throws
        -> Response
    {
        let formId = try context.requiredParameter("formId")
        let payload = try await request.decode(
            as: ListBulkRemoveFormInput.self,
            context: context
        )
        let (interactor, _) = buildRuntime(request, context)
        try await interactor.bulkRemove(
            formId: formId,
            ids: payload.normalizedSelectedIds
        )
        return Response(
            status: .seeOther,
            headers: [
                .location: ListBulkRemoveRedirect.location(
                    path: "/admin/contact/forms/\(formId)/fields/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: "Removed",
                    message: "Contact form fields removed successfully."
                )
            ]
        )
    }
}
