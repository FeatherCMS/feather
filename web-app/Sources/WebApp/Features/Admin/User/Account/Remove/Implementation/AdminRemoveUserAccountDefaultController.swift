import HTML
import Hummingbird

struct AdminRemoveUserAccountDefaultController: AdminRemoveUserAccountController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            getInteractor: any AdminGetUserAccountInteractor,
            removeInteractor: any AdminRemoveUserAccountInteractor,
            presenter: any AdminRemoveUserAccountPresenter
        )

    func getRemoveUserAccount(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (getInteractor, _, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        do {
            let account = try await getInteractor.execute(id: id)
            return presenter.renderPage(
                state: .init(
                    id: account.id,
                    email: account.email,
                    breadcrumb: presenter.breadcrumb(id: id)
                ),
                permissions: context.currentUserPermissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.errorPage(
                id: id,
                error: error,
                permissions: context.currentUserPermissions
            )
        }
    }

    func postRemoveUserAccount(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (_, removeInteractor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        do {
            try await removeInteractor.execute(entity: .init(id: id))
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/user/accounts/",
                        title: "Removed",
                        message: "User account removed successfully."
                    )
                ]
            )
        }
        catch let error as OpenAPIRepositoryError {
            return
                try presenter.errorPage(
                    id: id,
                    error: error,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
