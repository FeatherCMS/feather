import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import UserModule

extension Role.Edit.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Role.Edit.Interactor.Interface,
                any Role.Edit.Presenter.Interface
            >

        func getEditUserRole(
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
                    to: Role.Permissions.update
                )
            else { return try await presenter.renderForbiddenPage() }
            let id = try context.requiredID()
            do {
                let role = try await interactor.load(id: id)
                return try await presenter.renderEditPage(
                    id: id,
                    state: .edit(name: role.name, notes: role.notes)
                )
            }
            catch let error as Role.Edit.Error {
                return try await presenter.renderEditError(
                    id: id,
                    input: nil,
                    error: error
                )
            }
        }

        func postEditUserRole(
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
                    to: Role.Permissions.update
                )
            else {
                return try await presenter.renderForbiddenPage()
                    .response(from: request, context: context)
            }
            let id = try context.requiredID()
            var lastPayload: Role.Edit.Form.Input?
            do {
                let payload = try await request.decode(
                    as: NonceRequest<Role.Edit.Form.Input>.self,
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
                        error: error
                    )
                    .response(from: request, context: context)
            }
            catch let error as Role.Edit.Error {
                return
                    try await presenter.renderEditError(
                        id: id,
                        input: lastPayload,
                        error: error
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
