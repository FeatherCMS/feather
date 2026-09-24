import FeatherAdmin
import HTML
import Hummingbird
import SystemContracts

struct AdminViewSystemVariableDefaultController:
    AdminViewSystemVariableController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewSystemVariableInteractor,
            any AdminViewSystemVariablePresenter
        >

    func getSystemVariable(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: SystemPermissions.Variables.read)
        else {
            return try await runtime.presenter.renderErrorPage(
                error: .forbidden
            )
        }
        let id = try request.requiredID()
        do {
            let variable = try await runtime.interactor.execute(
                entity: .init(id: id)
            )
            return try await runtime.presenter.renderDetailsPage(
                variable: variable,
                permissions: context.currentUserAdminListActions,
            )
        }
        catch let error as AdminViewSystemVariableError {
            return try await runtime.presenter.renderErrorPage(
                error: error
            )
        }
    }
}
