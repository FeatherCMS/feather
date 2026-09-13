import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import SystemContracts

struct AdminAddSystemVariableDefaultController: AdminAddSystemVariableController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminAddSystemVariableInteractor,
            presenter: any AdminAddSystemVariablePresenter
        )

    func getAddSystemVariable(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        guard
            context.isCurrentUserAllowed(to: SystemPermissions.Variables.create)
        else {
            return try await runtime.presenter.renderForbiddenPage()
        }
        return try await runtime.presenter.renderAddPage(
            state: .empty()
        )
    }

    func postAddSystemVariable(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        guard
            context.isCurrentUserAllowed(to: SystemPermissions.Variables.create)
        else {
            return try await runtime.presenter
                .renderForbiddenPage()
                .response(from: request, context: context)
        }
        var lastPayload: SystemVariableAddFormInput?

        do {
            let payload = try await request.decode(
                as: SystemVariableAddFormInput.self,
                context: context
            )
            lastPayload = payload
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
            try await runtime.interactor.add(input: payload)

            return runtime.presenter.renderSuccess()
        }
        catch let error as ValidationError {
            return try await runtime.presenter
                .renderValidationError(
                    input: lastPayload,
                    error: error
                )
                .response(from: request, context: context)
        }
        catch let error as AdminAddSystemVariableError {
            return try await runtime.presenter
                .renderAddError(
                    input: lastPayload,
                    error: error
                )
                .response(from: request, context: context)
        }
    }

}
