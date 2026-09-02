import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactFormSubmissionsDefaultController:
    AdminRemoveContactFormSubmissionsController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveContactFormSubmissionsInteractor,
            presenter: any AdminRemoveContactFormSubmissionsPresenter
        )

    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let submissionId = try context.requiredParameter("submissionId")
        return presenter.renderConfirmation(
            formId: formId,
            item: try await interactor.get(formId: formId, id: submissionId),
            permissions: context.currentUserPermissions
        )
    }

    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let submissionId = try context.requiredParameter("submissionId")
        try await interactor.remove(formId: formId, id: submissionId)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/contact/forms/\(formId)/submissions/",
                    title: "Removed",
                    message: "Contact form submission removed successfully."
                )
            ]
        )
    }

    func confirmSelected(request: Request, context: DefaultRequestContext)
        async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime(request, context)
        return presenter.renderConfirmation(
            formId: try context.requiredParameter("formId"),
            selectedIds: request.queryStrings("selectedIds"),
            permissions: context.currentUserPermissions
        )
    }

    func removeSelected(request: Request, context: DefaultRequestContext)
        async throws
        -> Response
    {
        let formId = try context.requiredParameter("formId")
        let payload = try await request.decode(
            as: ListRemoveFormInput.self,
            context: context
        )
        let (interactor, _) = buildRuntime(request, context)
        try await interactor.remove(
            formId: formId,
            ids: payload.normalizedSelectedIds
        )
        return Response(
            status: .seeOther,
            headers: [
                .location: ListRemoveRedirect.location(
                    path: "/admin/contact/forms/\(formId)/submissions/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: "Removed",
                    message: "Contact form submissions removed successfully."
                )
            ]
        )
    }
}
