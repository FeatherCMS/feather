import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebComponents
import WebBuilders

struct AdminRemoveAuthCredentialDefaultController:
    AdminRemoveAuthCredentialController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveAuthCredentialInteractor,
            presenter: any AdminRemoveAuthCredentialPresenter
        )

    func getRemoveCredential(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    {
        let id = try context.requiredID()
        let (interactor, presenter) = buildRuntime(request, context)
        do {
            return presenter.renderPage(
                model: try await interactor.get(id: id),
                permissions: context.currentUserPermissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderError(
                id: id,
                error: error,
                permissions: context.currentUserPermissions
            )
        }
    }

    func postRemoveCredential(request: Request, context: DefaultRequestContext)
        async throws -> Response
    {
        let id = try context.requiredID()
        let (interactor, _) = buildRuntime(request, context)
        try await interactor.delete(id: id)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/auth/credentials/",
                    title: "Removed",
                    message: "User credential removed successfully."
                )
            ]
        )
    }
}
