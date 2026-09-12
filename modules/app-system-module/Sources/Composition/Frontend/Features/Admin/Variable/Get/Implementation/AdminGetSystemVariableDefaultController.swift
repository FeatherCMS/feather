import FeatherAdmin
import HTML
import Hummingbird
import SystemContracts

struct AdminGetSystemVariableDefaultController: AdminGetSystemVariableController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetSystemVariableInteractor,
            presenter: any AdminGetSystemVariablePresenter
        )

    func getSystemVariable(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        guard context.isCurrentUserAllowed(to: SystemPermissions.Variables.read)
        else {
            throw HTTPError(.forbidden)
        }
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        do {
            let variable = try await runtime.interactor.execute(
                entity: .init(id: id)
            )
            return try await runtime.presenter.renderDetailsPage(
                variable: variable,
                permissions: context.currentUserPermissions,
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter.renderErrorPage(
                info: error.errorTitle,
                message: error.errorDescription,
            )
        }
    }
}
