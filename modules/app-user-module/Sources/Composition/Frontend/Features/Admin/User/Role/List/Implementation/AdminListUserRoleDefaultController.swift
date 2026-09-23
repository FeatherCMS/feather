import FeatherAdmin
import FeatherContracts
import Hummingbird
import UserContracts

struct AdminListUserRoleDefaultController: AdminListUserRoleController {
    let buildRuntime: RuntimeBuilder<
        any AdminListUserRoleInteractor,
        any AdminListUserRolePresenter
    >

    func getUserRoles(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: UserPermissions.Roles.list)
        else { return try await presenter.renderErrorPage(error: .forbidden) }
        do {
            let model = try await interactor.list(
                page: request.queryPage(),
                size: AdminListUserRole.pageSize,
                search: request.querySearch()
            )
            return try await presenter.renderListPage(
                model: model,
                permissions: context.currentUserAdminListActions.granted,
                search: request.querySearch()
            )
        }
        catch let error as AdminListUserRoleError {
            return try await presenter.renderErrorPage(error: error)
        }
    }
}
