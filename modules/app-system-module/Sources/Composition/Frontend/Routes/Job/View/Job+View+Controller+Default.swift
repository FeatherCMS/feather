import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Job.View.Controller {
    struct Default: WebAdmin.System.Job.View.Controller.Interface {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any WebAdmin.System.Job.View.Interactor.Interface,
                any WebAdmin.System.Job.View.Presenter.Interface
            >

        func getSystemJob(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime((request, context))
            guard
                context.isCurrentUserAllowed(
                    to: SystemModule.Job.Permissions.read
                )
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
            catch let error as WebAdmin.System.Job.View.Error {
                return try await runtime.presenter.renderErrorPage(error: error)
            }
        }
    }
}
