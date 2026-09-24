import FeatherAdmin
import Hummingbird
import SystemContracts

struct AdminViewSystemJobDefaultController: AdminViewSystemJobController {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewSystemJobInteractor,
            any AdminViewSystemJobPresenter
        >

    func getSystemJob(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: SystemPermissions.Jobs.read)
        else {
            return try await runtime.presenter.renderErrorPage(
                error: .forbidden
            )
        }
        let id = try context.requiredID()
        do {
            let job = try await runtime.interactor.execute(
                entity: .init(id: id)
            )
            return try await runtime.presenter.renderDetailsPage(job: job)
        }
        catch let error as AdminViewSystemJobError {
            return try await runtime.presenter.renderErrorPage(error: error)
        }
    }
}
