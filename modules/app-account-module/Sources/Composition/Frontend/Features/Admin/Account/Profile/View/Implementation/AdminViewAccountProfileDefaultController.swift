import AccountContracts
import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminViewAccountProfileDefaultController:
    AdminViewAccountProfileController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewAccountProfileInteractor,
            any AdminViewAccountProfilePresenter
        >

    func getAccountProfile(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime((request, context))
        let account = context.account

        let permissions = account.permissionSet
        let accountProfile = try await runtime.interactor.getAccountProfile()
        let profile = try await runtime.interactor.getProfile(
            account: account,
            accountProfile: accountProfile
        )
        return try await runtime.presenter.renderPage(
            state: .init(
                profile: profile,
                canEdit: true,
                breadcrumb: AccountAdminRoutes.profileBreadcrumb
            ),
            permissions: permissions
        )
    }

}
