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

extension Email.Edit.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Email.Edit.Interactor.Interface,
                any Email.Edit.Presenter.Interface
            >

        func getEditAuthEmail(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let id = try context.requiredID()
            let isEdited = request.hasQueryFlag("edited")
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let permissions = context.currentUserPermissions
            guard
                context.isCurrentUserAllowed(
                    to: Email.Permissions.update
                )
            else {
                return try await presenter.renderError(
                    id: id,
                    error: .forbidden,
                    permissions: permissions
                )
            }
            do {
                let link = try await interactor.get(id: id)
                let identities = (try? await interactor.listIdentities()) ?? []
                return try await presenter.renderPage(
                    id: id,
                    isEdited: isEdited,
                    form: presenter.formState(
                        identityId: link.identityId,
                        identities: identities,
                        email: link.email
                    ),
                    permissions: permissions
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await presenter.renderError(
                    id: id,
                    error: error,
                    permissions: permissions
                )
            }
        }

        func postEditAuthEmail(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let id = try context.requiredID()
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard
                context.isCurrentUserAllowed(
                    to: Email.Permissions.update
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
            var lastPayload: Email.Edit.Form.Input?
            let identities = (try? await interactor.listIdentities()) ?? []
            do {
                let nonceRequest = try await request.decode(
                    as: NonceRequest<Email.Edit.Form.Input>.self,
                    context: context
                )
                guard
                    await AdminNonceStore.shared.consume(
                        nonceRequest.nonce,
                        sessionToken: context.sessionToken
                    )
                else {
                    var state = presenter.formState(
                        identityId: id,
                        identities: identities,
                        email: ""
                    )
                    state.error =
                        "This form has expired. Please reload the page."
                    return try await updateResponse(
                        request: request,
                        context: context,
                        id: id,
                        presenter: presenter,
                        state: state
                    )
                }
                let payload = nonceRequest.input
                lastPayload = payload
                try await payload.validate()
                try await interactor.execute(
                    entity: .init(
                        id: id,
                        identityId: payload.normalizedIdentityId,
                        email: payload.normalizedEmail
                    )
                )
                return AdminNotificationFlash.redirect(
                    to: "/admin/auth/emails/\(id)/edit/",
                    notification: .init(
                        title: "Saved",
                        message: "User email edited successfully."
                    )
                )
            }
            catch let error as ValidationError {
                var errs: [String: String] = [:]
                for f in error.failures { errs[f.key] = f.message }
                var state = presenter.formState(
                    identityId: lastPayload?.normalizedIdentityId ?? "",
                    identities: identities,
                    email: lastPayload?.normalizedEmail ?? ""
                )
                state.apply(errors: errs)
                return try await updateResponse(
                    request: request,
                    context: context,
                    id: id,
                    presenter: presenter,
                    state: state
                )
            }
            catch let error as OpenAPIRepositoryError {
                var state = presenter.formState(
                    identityId: lastPayload?.normalizedIdentityId ?? "",
                    identities: identities,
                    email: lastPayload?.normalizedEmail ?? ""
                )
                state.error = presenter.format(error: error)
                return try await updateResponse(
                    request: request,
                    context: context,
                    id: id,
                    presenter: presenter,
                    state: state
                )
            }
            catch {
                var state = presenter.formState(
                    identityId: lastPayload?.normalizedIdentityId ?? "",
                    identities: identities,
                    email: lastPayload?.normalizedEmail ?? ""
                )
                state.error = error.displayMessage
                return try await updateResponse(
                    request: request,
                    context: context,
                    id: id,
                    presenter: presenter,
                    state: state
                )
            }
        }

        private func updateResponse(
            request: Request,
            context: AuthenticatedRequestContext,
            id: String,
            presenter: any Email.Edit.Presenter.Interface,
            state: Email.Form.Component.State
        ) async throws -> Response {
            try await presenter.renderPage(
                id: id,
                isEdited: false,
                form: state,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
        }
    }
}
