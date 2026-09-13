import FeatherAdmin
import FeatherContracts
import Hummingbird
import UserContracts

struct AdminListUserIdentityDefaultController: AdminListUserIdentityController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListUserIdentityInteractor,
            presenter: any AdminListUserIdentityPresenter
        )

    func getUserIdentities(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: UserPermissions.Identities.list)
        else { return try await presenter.renderErrorPage(error: .forbidden) }
        let search = request.querySearch()
        let role = request.uri.queryParameters["role"].map(String.init)
        do {
            let model = try await interactor.list(
                page: request.queryPage(),
                size: AdminListUserIdentity.pageSize,
                search: search,
                role: role
            )
            return try await presenter.renderListPage(
                model: model,
                permissions: context.currentUserAdminListActions.granted,
                search: search,
                role: role
            )
        }
        catch let error as AdminListUserIdentityError {
            return try await presenter.renderErrorPage(error: error)
        }
    }
}
