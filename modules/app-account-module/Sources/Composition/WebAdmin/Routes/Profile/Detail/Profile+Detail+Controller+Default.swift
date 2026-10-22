import AccountModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Profile.Detail.Controller {

    struct Default:
        Profile.Detail.Controller.Interface
    {
        let routes: Profile.Router.Routes
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Profile.Detail.Interactor.Interface,
                any Profile.Detail.Presenter.Interface
            >

        func getProfile(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime((request, context))
            let account = context.account

            let permissions = account.permissionSet
            let profileModel = try await runtime.interactor
                .getProfile()
            let profile = try await runtime.interactor.getProfile(
                account: account,
                profile: profileModel
            )
            return try await runtime.presenter.renderPage(
                state: .init(
                    profile: profile,
                    canEdit: true,
                    breadcrumb: routes.profileBreadcrumb
                ),
                permissions: permissions
            )
        }

    }
}
