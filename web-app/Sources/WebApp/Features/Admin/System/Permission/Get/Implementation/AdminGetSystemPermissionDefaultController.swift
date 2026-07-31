import Hummingbird

struct AdminGetSystemPermissionDefaultController:
    AdminGetSystemPermissionController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetSystemPermissionInteractor,
            presenter: any AdminGetSystemPermissionPresenter
        )

    func getSystemPermission(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        do {
            let permission = try await interactor.execute(entity: .init(id: id))
            return presenter.renderDetailsPage(
                permission: permission,
                breadcrumb: presenter.breadcrumb(id: id),
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderErrorPage(
                info: error.errorTitle,
                message: error.errorDescription,
                breadcrumb: presenter.breadcrumb(id: id),
                permissions: permissions
            )
        }
    }
}
