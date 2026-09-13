import AccountContracts
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
import WebBuilders
import WebComponents

struct AdminViewAccountProfileDefaultController:
    AdminViewAccountProfileController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminViewAccountProfileInteractor,
            presenter: any AdminViewAccountProfilePresenter
        )

    func getAccountProfile(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        guard let account = context.account else {
            return try await runtime.presenter.renderDeniedPage(
                permissions: []
            )
        }

        let permissions = account.permissionSet
        guard
            context.isCurrentUserAllowed(
                to: AccountPermissions.Profile.read
            )
        else {
            return try await runtime.presenter.renderDeniedPage(
                permissions: permissions
            )
        }

        let accountProfile = try await runtime.interactor.getAccountProfile()
        let profile = try await runtime.interactor.getProfile(
            account: account,
            accountProfile: accountProfile
        )
        return try await runtime.presenter.renderPage(
            state: .init(
                profile: profile,
                canEdit: permissions.contains(
                    AccountPermissions.Profile.update.rawValue
                ),
                breadcrumb: breadcrumb()
            ),
            permissions: permissions
        )
    }

    private func breadcrumb() -> [NewAdminBreadcrumb.Link] {
        [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Account", link: "/admin/account/"),
            .init(label: "Profile", link: "/admin/account/profile/"),
        ]
    }
}
