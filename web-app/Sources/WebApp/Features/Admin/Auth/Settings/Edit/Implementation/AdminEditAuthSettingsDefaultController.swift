import Hummingbird

struct AdminEditAuthSettingsDefaultController:
    AdminEditAuthSettingsController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditAuthSettingsInteractor,
            presenter: any AdminEditAuthSettingsPresenter
        )

    func getEditAuthSettings(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let canRead = context.isCurrentUserAllowed(
            to: .read,
            scope: AdminAuth.Scope.settings
        )
        let canEdit = context.isCurrentUserAllowed(
            to: .update,
            scope: AdminAuth.Scope.settings
        )

        guard canRead else {
            return presenter.renderDeniedPage(
                info: "No permission",
                message: "Your account cannot view the settings.",
                permissions: permissions
            )
        }

        let settings = try await interactor.loadSettings()
        return presenter.renderPage(
            state: .init(
                isEdited: request.hasQueryFlag("edited"),
                canEdit: canEdit,
                form: .init(
                    language: .init(
                        key: "language",
                        label: "Language",
                        value: settings.language,
                        error: nil
                    ),
                    timezone: .init(
                        key: "timezone",
                        label: "Timezone",
                        value: settings.timezone,
                        error: nil
                    ),
                    pageSize: .init(
                        key: "pageSize",
                        label: "Pagination limit",
                        value: "\(settings.pageSize)",
                        error: nil
                    ),
                    canEdit: canEdit,
                    error: nil,
                    success: nil
                ),
                breadcrumb: breadcrumb()
            ),
            permissions: permissions
        )
    }

    func postEditAuthSettings(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (_, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let canEdit = context.isCurrentUserAllowed(
            to: .update,
            scope: AdminAuth.Scope.settings
        )

        guard canEdit else {
            return
                try presenter.renderDeniedPage(
                    info: "No permission",
                    message: "Your account cannot edit the settings.",
                    permissions: permissions
                )
                .response(from: request, context: context)
        }

        _ = try await request.decode(
            as: AdminEditAuthSettingsFormInput.self,
            context: context
        )
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/auth/settings/",
                    title: "Saved",
                    message: "Settings edited successfully."
                )
            ]
        )
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Auth", link: "/admin/auth/"),
                .init(label: "Settings", link: "/admin/auth/settings/"),
            ]
        )
    }
}
