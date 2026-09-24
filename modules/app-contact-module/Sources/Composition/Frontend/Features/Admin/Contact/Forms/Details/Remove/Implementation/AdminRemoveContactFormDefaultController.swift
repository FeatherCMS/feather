import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactFormDefaultController: AdminRemoveContactFormController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveContactFormInteractor,
            any AdminRemoveContactFormPresenter
        >

    func confirm(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        let selectedIds = request.queryStrings("selectedIds")
        guard selectedIds.count == 1, let formId = selectedIds.first else {
            return try await presenter.renderRemovePage(
                items: selectedIds.map { .init(id: $0, label: $0) }
            )
        }
        let item = try await interactor.get(id: formId)
        return try await presenter.renderRemovePage(
            items: [.init(id: formId, label: item.name)]
        )
    }

    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let payload = try await request.decode(
            as: NewAdminListRemoveFormInput.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                payload.nonce,
                sessionToken: context.sessionToken
            )
        else { return Response(status: .badRequest) }
        let (interactor, _) = buildRuntime((request, context))
        try await interactor.remove(ids: payload.normalizedSelectedIds)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminListRemoveRedirect.location(
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
