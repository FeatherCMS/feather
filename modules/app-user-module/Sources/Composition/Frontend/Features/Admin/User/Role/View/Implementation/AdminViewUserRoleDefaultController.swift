import FeatherAdmin
import Hummingbird
import UserContracts

struct AdminViewUserRoleDefaultController: AdminViewUserRoleController {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewUserRoleInteractor,
            any AdminViewUserRolePresenter
        >

    func getUserRole(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: UserPermissions.Roles.read)
        else {
            return try await runtime.presenter.renderErrorPage(
                error: .forbidden
            )
        }
        let id = try request.requiredID()
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
