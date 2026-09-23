import AuthAdminAPI
import AuthAppAPI
import AuthContracts
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
import WebBuilders
import WebComponents

struct AdminListAuthCredentialDefaultController:
    AdminListAuthCredentialController
{
    let buildRuntime:
        RuntimeBuilder<
            any AdminListAuthCredentialInteractor,
            any AdminListAuthCredentialPresenter
        >

    func getCredentials(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
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
                    page: page,
                    size: pageSize,
                    search: search
                )
                : (items: [], total: 0, page: page, size: pageSize)
            return try await presenter.renderPage(
                state: .init(
                    canAccess: canAccess,
                    permissions: permissions,
                    credentials: result.items,
                    page: result.page,
                    pageSize: result.size,
                    total: result.total,
                    search: search ?? "",
                    breadcrumb: AuthCredentialRoutes.listBreadcrumb
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await presenter.renderError(error: error)
        }
    }
}
