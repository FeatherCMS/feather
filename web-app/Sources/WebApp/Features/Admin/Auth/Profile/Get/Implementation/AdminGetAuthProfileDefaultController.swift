import Hummingbird

struct AdminGetAuthProfileDefaultController:
    AdminGetAuthProfileController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetAuthProfileInteractor,
            presenter: any AdminGetAuthProfilePresenter
        )

    func getAuthProfile(
        request: Request,
        context: AppRequestContext
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
                to: .read,
                scope: AdminAuth.Scope.profile
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
                    AdminAuth.Scope.profile.permission(for: .update)
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
