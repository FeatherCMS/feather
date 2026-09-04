import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminRemoveContactFormDefaultController: AdminRemoveContactFormController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveContactFormInteractor,
            presenter: any AdminRemoveContactFormPresenter
        )

    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let selectedIds = request.queryStrings("selectedIds")
        guard selectedIds.count == 1, let formId = selectedIds.first else {
            return presenter.renderConfirmation(
                selectedIds: selectedIds,
                permissions: context.currentUserPermissions
            )
        }
        let item = try await interactor.get(id: formId)
        return presenter.renderConfirmation(
            id: formId,
            name: item.name,
            permissions: context.currentUserPermissions
        )
    }

    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let payload = try await request.decode(
            as: ListRemoveFormInput.self,
            context: context
        )
        let (interactor, _) = buildRuntime(request, context)
        try await interactor.remove(ids: payload.normalizedSelectedIds)
        return Response(
            status: .seeOther,
            headers: [
                .location: ListRemoveRedirect.location(
                    path: "/admin/contact/forms/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: "Removed",
                    message: "Contact forms removed successfully."
                )
            ]
        )
    }
}
