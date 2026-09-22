import FeatherAdmin
import UserContracts
import Hummingbird

struct AdminViewUserRoleDefaultController: AdminViewUserRoleController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminViewUserRoleInteractor,
            presenter: any AdminViewUserRolePresenter
        )

    func getUserRole(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: UserPermissions.Roles.read)
        else {
            return try await runtime.presenter.renderErrorPage(
                error: .forbidden
            )
        }
        let id = try context.requiredID()
        do {
            let role = try await runtime.interactor.load(id: id)
            return try await runtime.presenter.renderDetailsPage(
                role: role,
                permissions: context.currentUserAdminListActions
            )
        }
        catch let error as AdminViewUserRoleError {
            return try await runtime.presenter.renderErrorPage(error: error)
        }
    }
}
