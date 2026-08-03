import Hummingbird

struct AdminListAuthCredentialDefaultController: AdminListAuthCredentialController {
    let buildRuntime: @Sendable (Request, AppRequestContext) -> (
        interactor: any AdminListAuthCredentialInteractor,
        presenter: any AdminListAuthCredentialPresenter
    )

    func getCredentials(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let accountID = try context.requiredID()
        let (interactor, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: .list,
            scope: AdminAuth.Scope.credentials
        )
        let page = request.queryPage()
        let pageSize = 20
        let search = request.querySearch()

        do {
            let result = canAccess
                ? try await interactor.execute(
                    accountID: accountID,
                    page: page,
                    size: pageSize,
                    search: search
                )
                : (items: [], total: 0, page: page, size: pageSize)
            return presenter.renderPage(
                state: .init(
                    accountID: accountID,
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
                            link: "/admin/auth/credentials/\(accountID)/"
                        ),
                    ])
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderError(error: error, accountID: accountID)
        }
    }
}
