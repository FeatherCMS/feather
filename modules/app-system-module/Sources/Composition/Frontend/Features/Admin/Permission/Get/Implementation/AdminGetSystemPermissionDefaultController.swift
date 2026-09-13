import FeatherAdmin
import Hummingbird
import SystemContracts

struct AdminGetSystemPermissionDefaultController:
    AdminGetSystemPermissionController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetSystemPermissionInteractor,
            presenter: any AdminGetSystemPermissionPresenter
        )

    func getSystemPermission(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        guard
            context.isCurrentUserAllowed(to: SystemPermissions.Permissions.read)
        else {
            return try await presenter.renderErrorPage(error: .forbidden)
        }
        let id = try context.requiredID()
        do {
            let permission = try await interactor.execute(entity: .init(id: id))
            return try await presenter.renderDetailsPage(
                permission: permission,
                permissions: context.currentUserAdminListActions
            )
        }
        catch let error as AdminGetSystemPermissionError {
            return try await presenter.renderErrorPage(error: error)
        }
    }
}
