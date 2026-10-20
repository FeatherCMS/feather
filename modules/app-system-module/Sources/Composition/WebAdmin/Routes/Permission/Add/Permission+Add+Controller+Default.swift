import FeatherAdmin
import FeatherValidation
import Hummingbird
import SystemModule

extension Permission.Add.Controller {
    struct Default:
        Interface
    {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Permission.Add.Interactor
                    .Interface,
                any Permission.Add.Presenter
                    .Interface
            >

        func getAddSystemPermission(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let (_, presenter) = buildRuntime((request, context))
            guard
                context.isCurrentUserAllowed(
                    to: SystemModule.Permission.Permissions.create
                )
            else {
                return try await presenter.renderForbiddenPage()
            }
            return try await presenter.renderAddPage(state: .empty())
        }

        func postAddSystemPermission(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let (interactor, presenter) = buildRuntime((request, context))
            guard
                context.isCurrentUserAllowed(
                    to: SystemModule.Permission.Permissions.create
                )
            else {
                return
                    try await presenter.renderForbiddenPage()
                    .response(from: request, context: context)
            }
            var lastPayload: SystemPermissionAddFormInput?

            do {
                let payload = try await request.decode(
                    as: NonceRequest<SystemPermissionAddFormInput>.self,
                    context: context
                )
                lastPayload = payload.input
                guard
                    await AdminNonceStore.shared.consume(
                        payload.nonce,
                        sessionToken: context.sessionToken
                    )
                else {
                    return
                        try await presenter.renderInvalidNoncePage()
                        .response(from: request, context: context)
                }
                try await payload.input.validate()

                try await interactor.execute(
                    entity: .init(
                        key: payload.input.normalizedKey,
                        name: payload.input.normalizedName,
                        notes: payload.input.normalizedNotes
                    )
                )

                return presenter.renderSuccess()
            }
            catch let error as ValidationError {
                return
                    try await presenter.renderValidationError(
                        input: lastPayload,
                        error: error
                    )
                    .response(from: request, context: context)
            }
            catch let error as Permission.Add.Error {
                return
                    try await presenter.renderAddError(
                        input: lastPayload,
                        error: error
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
