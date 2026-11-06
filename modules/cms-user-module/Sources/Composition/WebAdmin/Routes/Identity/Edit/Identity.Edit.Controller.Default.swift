import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Identity.Edit.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Identity.Edit.Interactor.Interface,
                any Identity.Edit.Presenter.Interface
            >

        func getEditUserIdentity(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> HTMLResponse
        {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard
                context.isCurrentUserAllowed(
                    to: Identity.Permissions.update
                )
            else { return try await presenter.renderForbiddenPage() }
            let id = try context.requiredID()
            do {
                let identity = try await interactor.load(id: id)
                let roles = try await interactor.loadRoleOptions()
                return try await presenter.renderEditPage(
                    id: id,
                    state: .from(
                        name: identity.name,
                        status: identity.status,
                        roleIds: identity.roleIds,
                        roleOptions: roles
                    )
                )
            }
            catch let error as Identity.Edit.Error {
                return try await presenter.renderEditError(
                    id: id,
                    input: nil,
                    error: error,
                    roleOptions: []
                )
            }
        }

        func postEditUserIdentity(
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
                    to: Identity.Permissions.update
                )
            else {
                return try await presenter.renderForbiddenPage()
                    .response(from: request, context: context)
            }
            let id = try context.requiredID()
            let roleOptions = (try? await interactor.loadRoleOptions()) ?? []
            var lastPayload: Identity.Edit.Form.Input?
            do {
                let payload = try await request.decode(
                    as: NonceRequest<Identity.Edit.Form.Input>.self,
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
                try await interactor.edit(id: id, input: input)
                return presenter.renderSuccess(id: id)
            }
            catch let error as ValidationError {
                return
                    try await presenter.renderValidationError(
                        id: id,
                        input: lastPayload,
                        error: error,
                        roleOptions: roleOptions
                    )
                    .response(from: request, context: context)
            }
            catch let error as Identity.Edit.Error {
                return
                    try await presenter.renderEditError(
                        id: id,
                        input: lastPayload,
                        error: error,
                        roleOptions: roleOptions
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
