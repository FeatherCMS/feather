import FeatherAdmin
import HTML
import Hummingbird
import UserContracts

struct AdminRemoveUserIdentityDefaultController:
    AdminRemoveUserIdentityController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            getInteractor: any AdminGetUserIdentityInteractor,
            removeInteractor: any AdminRemoveUserIdentityInteractor,
            presenter: any AdminRemoveUserIdentityPresenter
        )

    func getRemoveUserIdentity(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (getInteractor, _, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        do {
            let identity = try await getInteractor.execute(id: id)
            return presenter.renderPage(
                state: .init(
                    id: identity.id,
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

    func postRemoveUserIdentity(
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
                        defaultPath: "/admin/user/identities/",
                        title: "Removed",
                        message: "User identity removed successfully."
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
