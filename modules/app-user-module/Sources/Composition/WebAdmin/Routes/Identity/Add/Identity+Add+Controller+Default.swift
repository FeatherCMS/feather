import FeatherValidation
import FeatherWebShared
import FeatherWebAdmin
import Hummingbird
import UserModule

extension Identity.Add.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Identity.Add.Interactor.Interface,
                any Identity.Add.Presenter.Interface
            >

        func getAddUserIdentity(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard
                context.isCurrentUserAllowed(
                    to: Identity.Permissions.create
                )
            else {
                return try await presenter.renderForbiddenPage()
            }
            let roleOptions = (try? await interactor.loadRoleOptions()) ?? []
            return try await presenter.renderAddPage(
                state: .empty(roleOptions: roleOptions)
            )
        }

        func postAddUserIdentity(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard
                context.isCurrentUserAllowed(
                    to: Identity.Permissions.create
                )
            else {
                return try await presenter.renderForbiddenPage()
                    .response(from: request, context: context)
            }
            let roleOptions = (try? await interactor.loadRoleOptions()) ?? []
            var lastPayload: Identity.Add.FormInput?

            do {
                let payload = try await request.decode(
                    as: NonceRequest<Identity.Add.FormInput>.self,
                    context: context
                )
                let input = payload.input
                lastPayload = input
                guard
                    await AdminNonceStore.shared.consume(
                        payload.nonce,
                        sessionToken: context.sessionToken
                    )
                else {
                    return try await presenter.renderInvalidNoncePage()
                        .response(from: request, context: context)
                }
                try await input.validate()

                try await interactor.add(input: input)
                return presenter.renderSuccess()
            }
            catch let error as ValidationError {
                return
                    try await presenter.renderValidationError(
                        input: lastPayload,
                        error: error,
                        roleOptions: roleOptions
                    )
                    .response(from: request, context: context)
            }
            catch let error as Identity.Add.Error {
                return
                    try await presenter.renderAddError(
                        input: lastPayload,
                        error: error,
                        roleOptions: roleOptions
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
