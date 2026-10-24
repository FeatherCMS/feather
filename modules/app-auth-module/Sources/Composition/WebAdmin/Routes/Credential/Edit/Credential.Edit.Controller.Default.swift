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

extension Credential.Edit.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Credential.Edit.Interactor.Interface,
                any Credential.Edit.Presenter.Interface
            >

        func getEditCredential(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> HTMLResponse
        {
            let id = try context.requiredID()
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard
                context.isCurrentUserAllowed(
                    to: Credential.Permissions.update
                )
            else {
                return try await presenter.renderError(
                    id: id,
                    error: .forbidden,
                    permissions: context.currentUserPermissions
                )
            }
            do {
                let credential = try await interactor.get(id: id)
                let emails = try await interactor.listEmails()
                return try await presenter.renderPage(
                    id: id,
                    form: presenter.formState(
                        userId: credential.userId,
                        emails: emails,
                        email: credential.email,
                        password: ""
                    ),
                    permissions: context.currentUserPermissions
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await presenter.renderError(
                    id: id,
                    error: error,
                    permissions: context.currentUserPermissions
                )
            }
        }

        func postEditCredential(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> Response
        {
            let id = try context.requiredID()
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard
                context.isCurrentUserAllowed(
                    to: Credential.Permissions.update
                )
            else {
                return
                    try await presenter.renderError(
                        id: id,
                        error: .forbidden,
                        permissions: context.currentUserPermissions
                    )
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
                        emails: (try? await interactor.listEmails()) ?? [],
                        email: "",
                        password: ""
                    )
                    state.error =
                        "This form has expired. Please reload the page."
                    return
                        try await presenter.renderPage(
                            id: id,
                            form: state,
                            permissions: context.currentUserPermissions
                        )
                        .response(from: request, context: context)
                }
                payload = nonceRequest.input
                try await payload!.validate(requiredPassword: false)
                try await interactor.execute(
                    id: id,
                    payload: .init(
                        userId: payload!.normalizedUserId,
                        email: payload!.normalizedEmail,
                        password: payload!.normalizedPassword
                    )
                )
                return AdminNotificationFlash.redirect(
                    to: "/admin/auth/credentials/\(id)/edit/",
                    notification: .init(
                        title: "Saved",
                        message: "User credential edited successfully."
                    )
                )
            }
            catch let error as ValidationError {
                var state = presenter.formState(
                    userId: payload?.normalizedUserId ?? "",
                    emails: (try? await interactor.listEmails()) ?? [],
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
                        id: id,
                        form: state,
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }
            catch let error as OpenAPIRepositoryError {
                var state = presenter.formState(
                    userId: payload?.normalizedUserId ?? "",
                    emails: (try? await interactor.listEmails()) ?? [],
                    email: payload?.normalizedEmail ?? "",
                    password: ""
                )
                state.error = presenter.format(error: error)
                return
                    try await presenter.renderPage(
                        id: id,
                        form: state,
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }
            catch {
                var state = presenter.formState(
                    userId: payload?.normalizedUserId ?? "",
                    emails: (try? await interactor.listEmails()) ?? [],
                    email: payload?.normalizedEmail ?? "",
                    password: ""
                )
                state.error = error.displayMessage
                return
                    try await presenter.renderPage(
                        id: id,
                        form: state,
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
