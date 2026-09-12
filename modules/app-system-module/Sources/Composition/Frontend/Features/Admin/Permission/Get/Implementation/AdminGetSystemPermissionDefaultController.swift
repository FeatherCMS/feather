import FeatherAdmin
import FeatherContracts
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
            return try await presenter.renderErrorPage(
                info: "Forbidden",
                message: "Your account cannot access system permissions."
            )
        }
        let id = try context.requiredID()
        do {
            let permission = try await interactor.execute(entity: .init(id: id))
            return try await presenter.renderDetailsPage(
                permission: permission,
                permissions: context.currentUserAdminListActions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await presenter.renderErrorPage(
                info: error.errorTitle,
                message: error.errorDescription
            )
        }
        catch {
            return try await presenter.renderErrorPage(
                info: "Unable to load system permission.",
                message: error.displayMessage
            )
        }
    }
}
