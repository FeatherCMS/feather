import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension ContactModule.Form.Remove.Controller {
    struct Default: Interface {
        let routes: ContactModule.Form.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any ContactModule.Form.Remove.Interactor.Interface,
                any ContactModule.Form.Remove.Presenter.Interface
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
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            try await interactor.remove(keys: payload.input.normalizedIds)
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminListRemoveRedirect.location(
                        path: routes.forms.path,
                        page: payload.input.normalizedPage,
                        search: payload.input.normalizedSearch,
                        title: "Removed",
                        message: "Contact forms removed successfully."
                    )
                ]
            )
        }
    }
}
