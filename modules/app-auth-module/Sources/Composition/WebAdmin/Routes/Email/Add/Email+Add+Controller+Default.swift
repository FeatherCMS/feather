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

extension Email.Add.Controller {
    struct Default: Interface {

        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Email.Add.Interactor.Interface,
                any Email.Add.Presenter.Interface
            >

        func getAddAuthEmail(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let __runtimeBuild1 = buildRuntime(request, context)
            let interactor = __runtimeBuild1.interactor
            let presenter = __runtimeBuild1.presenter
            guard
                context.isCurrentUserAllowed(
                    to: Email.Permissions.create
                )
            else { return try await presenter.renderForbiddenPage() }
            let identities = (try? await interactor.listIdentities()) ?? []
            return try await presenter.renderPage(
                form: presenter.formState(
                    identityId: "",
                    identities: identities
                ),
                permissions: context.currentUserPermissions
            )
        }

        func postAddAuthEmail(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let __runtimeBuild2 = buildRuntime(request, context)
            let interactor = __runtimeBuild2.interactor
            let presenter = __runtimeBuild2.presenter
            guard
                context.isCurrentUserAllowed(
                    to: Email.Permissions.create
                )
            else {
                return try await presenter.renderForbiddenPage()
                    .response(from: request, context: context)
            }
            var lastPayload: Email.Add.Form.Input?
            let identities = (try? await interactor.listIdentities()) ?? []
            do {
                let nonceRequest = try await request.decode(
                    as: NonceRequest<Email.Add.Form.Input>.self,
                    context: context
                )
                guard
                    await AdminNonceStore.shared.consume(
                        nonceRequest.nonce,
                        sessionToken: context.sessionToken
                    )
                else {
                    var state = presenter.formState(
                        identityId: "",
                        identities: identities
                    )
                    state.error =
                        "This form has expired. Please reload the page."
                    return try await createResponse(
                        request: request,
                        context: context,
                        presenter: presenter,
                        state: state
                    )
                }
                let payload = nonceRequest.input
                lastPayload = payload
                try await payload.validate()
                try await interactor.execute(
                    entity: .init(
                        identityId: payload.normalizedIdentityId,
                        email: payload.normalizedEmail
                    )
                )
                return AdminNotificationFlash.redirect(
                    to: "/admin/auth/emails/",
                    notification: .init(
                        title: "Added",
                        message: "User email added successfully."
                    )
                )
            }
            catch let error as ValidationError {
                var errs: [String: String] = [:]
                for f in error.failures { errs[f.key] = f.message }
                var state = presenter.formState(
                    identityId: lastPayload?.normalizedIdentityId ?? "",
                    identities: identities
                )
                state.apply(errors: errs)
                return try await createResponse(
                    request: request,
                    context: context,
                    presenter: presenter,
                    state: state
                )
            }
            catch let error as OpenAPIRepositoryError {
                var state = presenter.formState(
                    identityId: lastPayload?.normalizedIdentityId ?? "",
                    identities: identities
                )
                state.error = presenter.format(error: error)
                return try await createResponse(
                    request: request,
                    context: context,
                    presenter: presenter,
                    state: state
                )
            }
            catch {
                var state = presenter.formState(
                    identityId: lastPayload?.normalizedIdentityId ?? "",
                    identities: identities
                )
                state.error = error.displayMessage
                return try await createResponse(
                    request: request,
                    context: context,
                    presenter: presenter,
                    state: state
                )
            }
        }

        private func createResponse(
            request: Request,
            context: AuthenticatedRequestContext,
            presenter: any Email.Add.Presenter.Interface,
            state: Email.Form.Component.State
        ) async throws -> Response {
            try await presenter.renderPage(
                form: state,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
        }
    }
}
