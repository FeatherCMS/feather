import FeatherAdmin
import Hummingbird
import SystemContracts

struct AdminListSystemPermissionDefaultController:
    AdminListSystemPermissionController
{
    let buildRuntime: RuntimeBuilder<
        any AdminListSystemPermissionInteractor,
        any AdminListSystemPermissionPresenter
    >

    func getSystemPermissions(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let permissions = context.currentUserAdminListActions
        guard permissions.allows(SystemPermissions.Permissions.list) else {
            return try await presenter.renderErrorPage(error: .forbidden)
        }
        do {
            let model = try await interactor.listSystemPermissions(
                page: request.queryPage(),
                search: request.querySearch()
            )
            return try await presenter.renderListPage(
                model: model,
                permissions: permissions,
                search: request.querySearch()
            )
        }
        catch let error as AdminListSystemPermissionError {
            return try await presenter.renderErrorPage(error: error)
        }
    }
}
