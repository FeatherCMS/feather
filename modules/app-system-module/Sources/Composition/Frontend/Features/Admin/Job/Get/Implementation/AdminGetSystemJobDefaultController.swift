import FeatherAdmin
import Hummingbird
import SystemContracts

struct AdminGetSystemJobDefaultController: AdminGetSystemJobController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetSystemJobInteractor,
            presenter: any AdminGetSystemJobPresenter
        )

    func getSystemJob(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
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
        catch let error as AdminGetSystemJobError {
            return try await runtime.presenter.renderErrorPage(error: error)
        }
    }
}
