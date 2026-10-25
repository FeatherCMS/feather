import FeatherWebAdmin
import FeatherWebShared
import FeatherModuleKit
import FeatherValidation
import HTML
import Hummingbird
import SystemModule

extension Variable.Edit.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Variable.Edit.Interactor.Interface,
                any Variable.Edit.Presenter.Interface
            >

        func getEditSystemVariable(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            guard
                context.isCurrentUserAllowed(
                    to: SystemModule.Variable.Permissions.update
                )
            else {
                return try await runtime.presenter.renderErrorPage(
                    error: .forbidden
                )
            }
            let id = try context.requiredID()
            let permissions = context.currentUserAdminListActions.granted
            do {
                let variable = try await runtime.interactor.load(id: id)
                return try await runtime.presenter.renderEditPage(
                    id: id,
                    deleteID: variable.id,
                    state: .from(variable: variable),
                    permissions: permissions
                )
            }
            catch let error as Variable.Edit.Error {
                return try await runtime.presenter.renderErrorPage(
                    error: error
                )
            }
        }

        func postEditSystemVariable(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            guard
                context.isCurrentUserAllowed(
                    to: SystemModule.Variable.Permissions.update
                )
            else {
                return try await runtime.presenter
                    .renderErrorPage(
                        error: .forbidden
                    )
                    .response(from: request, context: context)
            }
            let id = try context.requiredID()
            let permissions = context.currentUserAdminListActions.granted
            var lastPayload: Variable.Edit.Form.Input?

            do {
                let payload = try await request.decode(
                    as: NonceRequest<Variable.Edit.Form.Input>.self,
                    context: context
                )
                lastPayload = payload.input
                guard
                    await AdminNonceStore.shared.consume(
                        payload.nonce,
                        sessionToken: context.sessionToken
                    )
                else {
                    return try await runtime.presenter
                        .renderInvalidNoncePage()
                        .response(from: request, context: context)
                }
                try await payload.input.validate()
                try await runtime.interactor.edit(id: id, input: payload.input)

                return runtime.presenter.renderSuccess(id: id)
            }
            catch let error as ValidationError {
                return try await runtime.presenter
                    .renderValidationError(
                        id: id,
                        input: lastPayload,
                        permissions: permissions,
                        error: error
                    )
                    .response(from: request, context: context)
            }
            catch let error as Variable.Edit.Error {
                return try await runtime.presenter
                    .renderEditError(
                        id: id,
                        input: lastPayload,
                        permissions: permissions,
                        error: error
                    )
                    .response(from: request, context: context)
            }
        }

    }
}
