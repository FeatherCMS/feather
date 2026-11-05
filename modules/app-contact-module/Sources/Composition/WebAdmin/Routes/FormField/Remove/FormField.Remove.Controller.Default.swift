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

extension FormField.Remove.Controller {
    struct Default: Interface {
        let routes: FormField.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any FormField.Remove.Interactor.Interface,
                any FormField.Remove.Presenter.Interface
            >

        func remove(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> Response
        {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard context.isCurrentUserAllowed(to: FormField.Permissions.delete)
            else {
                return
                    try await presenter
                    .renderForbiddenPage()
                    .response(from: request, context: context)
            }
            let nonceRequest = try await request.decode(
                as: NonceRequest<AdminListRemoveFormInput>.self,
                context: context
            )
            guard
                await AdminNonceStore.shared.consume(
                    nonceRequest.nonce,
                    sessionToken: context.sessionToken
                )
            else { return Response(status: .badRequest) }
            try await interactor.remove(
                id: try context.requiredParameter("fieldId")
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminNotificationRedirect.location(
                        defaultPath: routes.fields.path,
                        title: "Removed",
                        message: "Contact field removed successfully."
                    )
                ]
            )
        }

        func removeSelected(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws
            -> Response
        {
            let payload = try await request.decode(
                as: NonceRequest<AdminListRemoveFormInput>.self,
                context: context
            )
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard context.isCurrentUserAllowed(to: FormField.Permissions.delete)
            else {
                return
                    try await presenter
                    .renderForbiddenPage()
                    .response(from: request, context: context)
            }
            guard
                await AdminNonceStore.shared.consume(
                    payload.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                return Response(status: .badRequest)
            }
            try await interactor.remove(ids: payload.input.normalizedIds)
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminListRemoveRedirect.location(
                        path: routes.fields.path,
                        page: payload.input.normalizedPage,
                        search: payload.input.normalizedSearch,
                        title: "Removed",
                        message: "Contact fields removed successfully."
                    )
                ]
            )
        }

    }
}
