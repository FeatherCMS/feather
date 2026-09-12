import FeatherAdmin
import FeatherContracts
import Hummingbird
import SystemContracts

struct AdminListSystemPermissionDefaultController:
    AdminListSystemPermissionController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListSystemPermissionInteractor,
            presenter: any AdminListSystemPermissionPresenter
        )

    func getSystemPermissions(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserAdminListActions
        guard permissions.allows(SystemPermissions.Permissions.list) else {
            return try await presenter.renderErrorPage(
                title: "Forbidden",
                message: "Your account cannot access system permissions."
            )
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
        catch {
            return try await presenter.renderErrorPage(
                title: "Unable to load system permissions.",
                message: error.displayMessage
            )
        }
    }
}
