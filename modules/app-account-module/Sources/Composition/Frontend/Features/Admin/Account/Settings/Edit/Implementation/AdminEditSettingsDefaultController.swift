import AccountContracts
import FeatherAdmin
import Hummingbird

struct AdminEditSettingsDefaultController:
    AdminEditSettingsController
{
    let buildRuntime: RuntimeBuilder<
        any AdminEditSettingsInteractor,
        any AdminEditSettingsPresenter
    >

    func getEditSettings(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let targetUserID = context.parameters.get("userId", as: String.self)
        let (interactor, presenter) = buildRuntime((request, context))
        let permissions = context.currentUserPermissions
        let isTargetUser = targetUserID != nil
        let canRead = context.isCurrentUserAllowed(
            to: isTargetUser
                ? AccountPermissions.Settings.manage
                : AccountPermissions.Settings.read
        )
        let canEdit = context.isCurrentUserAllowed(
            to: isTargetUser
                ? AccountPermissions.Settings.manage
                : AccountPermissions.Settings.update
        )

        guard canRead else {
            return try await presenter.renderDeniedPage(
                info: "No permission",
                message: "Your account cannot view the settings.",
                permissions: permissions
            )
        }

        let settings = try await interactor.loadSettings()
        return try await presenter.renderPage(
            state: .init(
                userID: targetUserID,
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
                breadcrumb: AccountAdminRoutes.settingsBreadcrumb
            ),
            permissions: permissions
        )
    }

    func postEditSettings(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let targetUserID = context.parameters.get("userId", as: String.self)
        let (interactor, presenter) = buildRuntime((request, context))
        let permissions = context.currentUserPermissions
        let isTargetUser = targetUserID != nil
        let canEdit = context.isCurrentUserAllowed(
            to: isTargetUser
                ? AccountPermissions.Settings.manage
                : AccountPermissions.Settings.update
        )

        guard canEdit else {
            return
                try await presenter.renderDeniedPage(
                    info: "No permission",
                    message: "Your account cannot edit the settings.",
                    permissions: permissions
                )
                .response(from: request, context: context)
        }

        let nonceRequest = try await request.decode(
            as: NonceRequest<AdminEditSettingsFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                nonceRequest.nonce,
                sessionToken: context.sessionToken
            )
        else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminNotificationRedirect.location(
                        defaultPath: request.uri.path,
                        title: "Expired",
                        message:
                            "This form has expired. Please reload the page."
                    )
                ]
            )
        }
        try await interactor.saveSettings(input: nonceRequest.input)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminNotificationRedirect.location(
                    defaultPath: request.uri.path,
                    title: "Saved",
                    message: "Settings edited successfully."
                )
            ]
        )
    }

}
