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

struct AdminGetAuthProfileDefaultController:
    AdminGetAuthProfileController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetAuthProfileInteractor,
            presenter: any AdminGetAuthProfilePresenter
        )

    func getAuthProfile(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        guard let account = context.account else {
            return presenter.renderDeniedPage(
                permissions: []
            )
        }

        let permissions = account.permissionSet
        guard
            context.isCurrentUserAllowed(
                to: AuthPermissions.Profile.read
            )
        else {
            return presenter.renderDeniedPage(
                permissions: permissions
            )
        }

        let profile = try await interactor.getProfile(account: account)
        return presenter.renderPage(
            state: .init(
                profile: profile,
                canEdit: permissions.contains(
                    AuthPermissions.Profile.update.rawValue
                ),
                breadcrumb: breadcrumb()
            ),
            permissions: permissions
        )
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Auth", link: "/admin/auth/"),
                .init(label: "Profile", link: "/admin/auth/profile/"),
            ]
        )
    }
}
