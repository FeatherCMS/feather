import Hummingbird

struct AdminEditAccountSettingsDefaultController:
    AdminEditAccountSettingsController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditAccountSettingsInteractor,
            presenter: any AdminEditAccountSettingsPresenter
        )

    func getEditAccountSettings(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let canRead = context.isCurrentUserAllowed(
            to: .read,
            scope: AdminAccount.Scope.settings
        )
        let canEdit = context.isCurrentUserAllowed(
            to: .update,
            scope: AdminAccount.Scope.settings
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

    func postEditAccountSettings(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let canEdit = context.isCurrentUserAllowed(
            to: .update,
            scope: AdminAccount.Scope.settings
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

        let input = try await request.decode(
            as: AdminEditAccountSettingsFormInput.self,
            context: context
        )
        try await interactor.saveSettings(input: input)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/account/settings/",
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
                .init(label: "Account", link: "/admin/account/"),
                .init(label: "Settings", link: "/admin/account/settings/"),
            ]
        )
    }
}
