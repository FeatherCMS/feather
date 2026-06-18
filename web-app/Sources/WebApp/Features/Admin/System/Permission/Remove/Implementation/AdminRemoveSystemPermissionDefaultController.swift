import Hummingbird

struct AdminRemoveSystemPermissionDefaultController:
    AdminRemoveSystemPermissionController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminRemoveSystemPermissionInteractor,
            presenter: any AdminRemoveSystemPermissionPresenter
        )

    func getRemoveSystemPermission(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions

        do {
            let permission = try await interactor.get(id: id)
            return presenter.renderRemovePage(
                id: id,
                name: permission.name,
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderErrorPage(
                id: id,
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }

    func postRemoveSystemPermission(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions

        do {
            try await interactor.delete(id: id)
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/system/permissions/",
                        title: "Removed",
                        message: "System permission removed successfully."
                    )
                ]
            )
        }
        catch let error as OpenAPIRepositoryError {
            return
                try presenter.renderErrorPage(
                    id: id,
                    info: error.errorTitle,
                    message: error.errorDescription,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
    }
}
