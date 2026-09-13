import FeatherAdmin
import HTML
import Hummingbird
import UserContracts

struct AdminGetUserRoleDefaultController: AdminGetUserRoleController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetUserRoleInteractor,
            presenter: any AdminGetUserRolePresenter
        )

    func getUserRole(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: UserPermissions.Roles.read) else {
            return try await runtime.presenter.renderErrorPage(error: .forbidden)
        }
        let id = try context.requiredID()
        do {
            let role = try await runtime.interactor.load(id: id)
            return try await runtime.presenter.renderDetailsPage(
                role: role,
                permissions: context.currentUserAdminListActions
            )
        } catch let error as AdminGetUserRoleError {
            return try await runtime.presenter.renderErrorPage(error: error)
        }
    }
}
