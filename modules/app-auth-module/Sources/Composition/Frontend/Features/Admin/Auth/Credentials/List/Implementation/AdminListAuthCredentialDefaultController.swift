import AuthContracts
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

struct AdminListAuthCredentialDefaultController:
    AdminListAuthCredentialController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListAuthCredentialInteractor,
            presenter: any AdminListAuthCredentialPresenter
        )

    func getCredentials(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let identityId = try context.requiredID()
        let (interactor, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: AuthPermissions.Credential.list
        )
        let page = request.queryPage()
        let pageSize = 20
        let search = request.querySearch()

        do {
            let result =
                canAccess
                ? try await interactor.execute(
                    identityId: identityId,
                    page: page,
                    size: pageSize,
                    search: search
                )
                : (items: [], total: 0, page: page, size: pageSize)
            return presenter.renderPage(
                state: .init(
                    identityId: identityId,
                    canAccess: canAccess,
                    permissions: permissions,
                    credentials: result.items,
                    page: result.page,
                    pageSize: result.size,
                    total: result.total,
                    search: search ?? "",
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Auth", link: "/admin/auth/"),
                        .init(
                            label: "Credentials",
                            link: "/admin/auth/credentials/"
                        ),
                        .init(
                            label: "User",
                            link: "/admin/auth/credentials/\(identityId)/"
                        ),
                    ])
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderError(error: error, identityId: identityId)
        }
    }
}
