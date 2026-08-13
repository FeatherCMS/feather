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
import WebStandards

struct AdminRemoveAuthCredentialDefaultController:
    AdminRemoveAuthCredentialController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminRemoveAuthCredentialInteractor,
            presenter: any AdminRemoveAuthCredentialPresenter
        )

    func getRemoveCredential(request: Request, context: AppRequestContext)
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

    func postRemoveCredential(request: Request, context: AppRequestContext)
        async throws -> Response
    {
        let id = try context.requiredID()
        let (interactor, _) = buildRuntime(request, context)
        let credential = try await interactor.get(id: id)
        try await interactor.delete(id: id)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath:
                        "/admin/auth/credentials/\(credential.userId)/",
                    title: "Removed",
                    message: "User credential removed successfully."
                )
            ]
        )
    }
}
