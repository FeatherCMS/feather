import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

extension Credential.Add.Controller {
    struct Default: Interface {
        let routes: Credential.Router.Routes

        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Credential.Add.Interactor.Interface,
                any Credential.Add.Presenter.Interface
            >

        func getAddCredential(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> HTMLResponse
        {
            let runtime = buildRuntime(request, context)
            let presenter = runtime.presenter
            guard
                context.isCurrentUserAllowed(
                    to: Credential.Permissions.create
                )
            else { return try await presenter.renderForbiddenPage() }
            return try await presenter.renderPage(
                form: presenter.formState(
                    userId: "",
                    email: "",
                    password: ""
                ),
                permissions: context.currentUserPermissions
            )
        }

        func postAddCredential(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> Response
        {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard
                context.isCurrentUserAllowed(
                    to: Credential.Permissions.create
                )
            else {
                return try await presenter.renderForbiddenPage()
                    .response(from: request, context: context)
            }
            var payload: Credential.Form.Input?
            do {
                let nonceRequest = try await request.decode(
                    as: NonceRequest<Credential.Form.Input>.self,
                    context: context
                )
                guard
                    await AdminNonceStore.shared.consume(
                        nonceRequest.nonce,
                        sessionToken: context.sessionToken
                    )
                else {
                    var state = presenter.formState(
                        userId: "",
                        email: "",
                        password: ""
                    )
                    state.error =
                        "This form has expired. Please reload the page."
                    return
                        try await presenter.renderPage(
                            form: state,
                            permissions: context.currentUserPermissions
                        )
                        .response(from: request, context: context)
                }
                payload = nonceRequest.input
                try await payload!
                    .validate(
                        requiredPassword: true,
                        validateUserId: false
                    )
                try await interactor.execute(
                    payload: .init(
                        userId: payload!.normalizedUserId,
                        email: payload!.normalizedEmail,
                        password: payload!.normalizedPassword
                    )
                )
                return AdminNotification.redirect(
                    to: routes.list.path,
                    notification: .init(
                        title: "Added",
                        message: "User credential added successfully."
                    )
                )
            }
            catch let error as ValidationError {
                var state = presenter.formState(
                    userId: payload?.normalizedUserId ?? "",
                    email: payload?.normalizedEmail ?? "",
                    password: ""
                )
                var errors: [String: String] = [:]
                for failure in error.failures {
                    precondition(
                        errors.updateValue(failure.message, forKey: failure.key)
                            == nil
                    )
                }
                state.apply(errors: errors)
                return
                    try await presenter.renderPage(
                        form: state,
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }
            catch let error as OpenAPIRepositoryError {
                var state = presenter.formState(
                    userId: payload?.normalizedUserId ?? "",
                    email: payload?.normalizedEmail ?? "",
                    password: ""
                )
                state.error = presenter.format(error: error)
                return
                    try await presenter.renderPage(
                        form: state,
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }
            catch {
                var state = presenter.formState(
                    userId: payload?.normalizedUserId ?? "",
                    email: payload?.normalizedEmail ?? "",
                    password: ""
                )
                state.error = error.displayMessage
                return
                    try await presenter.renderPage(
                        form: state,
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
