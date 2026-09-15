import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import SystemContracts

struct AdminEditSystemVariableDefaultController:
    AdminEditSystemVariableController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminEditSystemVariableInteractor,
            presenter: any AdminEditSystemVariablePresenter
        )

    func getEditSystemVariable(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        guard
            context.isCurrentUserAllowed(to: SystemPermissions.Variables.update)
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
                state: .from(variable: variable),
                permissions: permissions
            )
        }
        catch let error as AdminEditSystemVariableError {
            return try await runtime.presenter.renderErrorPage(
                error: error
            )
        }
    }

    func postEditSystemVariable(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        guard
            context.isCurrentUserAllowed(to: SystemPermissions.Variables.update)
        else {
            return try await runtime.presenter
                .renderErrorPage(
                    error: .forbidden
                )
                .response(from: request, context: context)
        }
        let id = try context.requiredID()
        let permissions = context.currentUserAdminListActions.granted
        var lastPayload: SystemVariableEditFormInput?

        do {
            let payload = try await request.decode(
                as: NonceRequest<SystemVariableEditFormInput>.self,
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
        catch let error as AdminEditSystemVariableError {
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
