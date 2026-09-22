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
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveContactFormInteractor,
            presenter: any AdminRemoveContactFormPresenter
        )

    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let keys = request.queryStrings("ids")
        guard keys.count == 1, let formKey = keys.first else {
            return try await presenter.renderRemovePage(
                items: keys.map { .init(id: $0, label: $0) }
            )
        }
        let item = try await interactor.get(key: formKey)
        return try await presenter.renderRemovePage(
            items: [.init(id: formKey, label: item.name)]
        )
    }

    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let payload = try await request.decode(
            as: NonceRequest<NewAdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                payload.nonce,
                sessionToken: context.sessionToken
            )
        else { return Response(status: .badRequest) }
        let (interactor, _) = buildRuntime(request, context)
        try await interactor.remove(keys: payload.input.normalizedIds)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminListRemoveRedirect.location(
                    path: "/admin/contact/forms/",
                    page: payload.input.normalizedPage,
                    search: payload.input.normalizedSearch,
                    title: "Removed",
                    message: "Contact forms removed successfully."
                )
            ]
        )
    }
}
