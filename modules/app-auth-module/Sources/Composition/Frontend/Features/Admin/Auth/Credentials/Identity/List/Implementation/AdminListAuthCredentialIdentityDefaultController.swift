import AuthAdminAPI
import AuthAppAPI
import AuthContracts
import CSS
import FeatherAdmin
import FeatherContracts
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

struct AdminListAuthCredentialIdentityDefaultController:
    AdminListAuthCredentialIdentityController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListAuthCredentialIdentityInteractor,
            presenter: any AdminListAuthCredentialIdentityPresenter
        )

    func getIdentities(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let canAccess =
            context.isCurrentUserAllowed(
                to: AuthPermissions.Credential.list
            )
            && context.isCurrentUserAllowed(
                to: PermissionKey("user:identities:list")
            )
        let page = request.queryPage()
        let pageSize = 20
        let search = request.querySearch()

        do {
            let result =
                canAccess
                ? try await interactor.execute(
                    page: page,
                    size: pageSize,
                    search: search
                )
                : (items: [], total: 0, page: page, size: pageSize)
            return presenter.renderPage(
                state: .init(
                    canAccess: canAccess,
                    permissions: permissions,
                    identities: result.items,
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
                    ])
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderError(error: error)
        }
    }
}
