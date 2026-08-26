import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactFormEmailDefaultController:
    AdminRemoveContactFormEmailController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveContactFormEmailInteractor,
            presenter: any AdminRemoveContactFormEmailPresenter
        )

    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let selectedIds = request.queryStrings("selectedIds")
        if selectedIds.count == 1, let mailId = selectedIds.first {
            let form = try await interactor.get(id: formId)
            guard let mail = form.mails.first(where: { $0.id == mailId }) else {
                throw HTTPError(.notFound)
            }
            return presenter.renderPage(
                formId: formId,
                mail: mail,
                permissions: context.currentUserPermissions
            )
        }
        return presenter.renderBulkConfirmation(
            formId: formId,
            selectedIds: request.queryStrings("selectedIds"),
            permissions: context.currentUserPermissions
        )
    }

    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let payload = try await request.decode(
            as: ListBulkRemoveFormInput.self,
            context: context
        )
        let (interactor, _) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        try await interactor.bulkRemove(
            id: formId,
            emailIds: payload.normalizedSelectedIds
        )
        return Response(
            status: .seeOther,
            headers: [
                .location: ListBulkRemoveRedirect.location(
                    path: "/admin/contact/forms/\(formId)/emails/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: "Removed",
                    message: "Contact form emails removed successfully."
                )
            ]
        )
    }
}
