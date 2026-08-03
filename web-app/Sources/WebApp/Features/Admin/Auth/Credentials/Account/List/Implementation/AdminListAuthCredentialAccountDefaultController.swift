import Hummingbird

struct AdminListAuthCredentialAccountDefaultController:
    AdminListAuthCredentialAccountController
{
    let buildRuntime: @Sendable (Request, AppRequestContext) -> (
        interactor: any AdminListAuthCredentialAccountInteractor,
        presenter: any AdminListAuthCredentialAccountPresenter
    )

    func getAccounts(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: .list,
            scope: AdminAuth.Scope.credentials
        ) && context.isCurrentUserAllowed(
            to: .list,
            scope: AdminUser.Scope.accounts
        )
        let page = request.queryPage()
        let pageSize = 20
        let search = request.querySearch()

        do {
            let result = canAccess
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
                    accounts: result.items,
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
