import FeatherWebAdmin
import FeatherWebShared
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
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminRemoveContactFormInteractor,
            any AdminRemoveContactFormPresenter
        >


    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let payload = try await request.decode(
            as: NonceRequest<AdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                payload.nonce,
                sessionToken: context.sessionToken
            )
        else { return Response(status: .badRequest) }
        let interactor = buildRuntime(request, context).interactor
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
