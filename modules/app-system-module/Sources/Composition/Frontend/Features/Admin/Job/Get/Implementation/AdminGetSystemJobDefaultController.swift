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
                info: "Forbidden",
                message: "Your account cannot access worker jobs."
            )
        }
        let id = try context.requiredID()
        do {
            let job = try await runtime.interactor.execute(
                entity: .init(id: id)
            )
            return try await runtime.presenter.renderDetailsPage(job: job)
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter.renderErrorPage(
                info: error.errorTitle,
                message: error.errorDescription
            )
        }
    }
}
