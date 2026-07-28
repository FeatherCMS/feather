import Hummingbird

struct AdminRemoveContactFormFieldDefaultController:
    AdminRemoveContactFormFieldController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminRemoveContactFormFieldInteractor,
            presenter: any AdminRemoveContactFormFieldPresenter
        )
    func confirm(request: Request, context: AppRequestContext) async throws
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
    func remove(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let formId = context.parameters.get("formId", as: String.self) ?? ""
        try await interactor.remove(
            formId: formId,
            id: try context.requiredParameter("fieldId")
        )
        let basePath =
            formId.isEmpty
            ? "/admin/contact/fields/" : "/admin/contact/forms/\(formId)/items/"
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
    func bulkConfirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime(request, context)
        let formId = context.parameters.get("formId", as: String.self) ?? ""
        return presenter.renderBulkConfirmation(
            formId: formId,
            selectedIds: request.queryStrings("selectedIds"),
            permissions: context.currentUserPermissions
        )
    }
    func bulkRemove(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let formId = context.parameters.get("formId", as: String.self) ?? ""
        let payload = try await request.decode(
            as: ListBulkRemoveFormInput.self,
            context: context
        )
        let (interactor, _) = buildRuntime(request, context)
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.bulkRemove(
                formId: formId,
                ids: payload.normalizedSelectedIds
            )
        }
        let basePath =
            formId.isEmpty
            ? "/admin/contact/fields/" : "/admin/contact/forms/\(formId)/items/"
        return Response(
            status: .seeOther,
            headers: [
                .location: ListBulkRemoveRedirect.location(
                    path: basePath,
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: payload.normalizedSelectedIds.isEmpty
                        ? nil : "Removed",
                    message: payload.normalizedSelectedIds.isEmpty
                        ? nil : "Contact form fields removed successfully."
                )
            ]
        )
    }
}
