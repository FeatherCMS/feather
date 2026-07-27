import HTML
import Hummingbird

struct AdminRemoveUserRoleDefaultController: AdminRemoveUserRoleController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminRemoveUserRoleInteractor,
            presenter: any AdminRemoveUserRolePresenter
        )

    func getRemoveUserRole(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        do {
            let role = try await interactor.get(id: id)
            return presenter.renderRemovePage(
                id: id,
                name: role.name,
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

    func postRemoveUserRole(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        do {
            try await interactor.execute(
                entity: .init(id: id)
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/user/roles/",
                        title: "Removed",
                        message: "User role removed successfully."
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
