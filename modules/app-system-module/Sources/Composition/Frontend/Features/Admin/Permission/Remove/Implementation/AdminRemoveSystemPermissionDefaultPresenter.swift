import FeatherAdmin
import Hummingbird
import SystemContracts
import WebComponents

struct AdminRemoveSystemPermissionDefaultPresenter:
    AdminRemoveSystemPermissionPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderRemovePage(
        page: Int,
        search: String?,
        ids: [String],
        names: [String],
        returnTo: String?
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        let cancel = NewAdminLocation.removeCancel(
            path: SystemPermissionRoutes.list.description,
            returnTo: returnTo
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage system permissions",
            content: NewAdminConfirmation(
                breadcrumb: SystemPermissionRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove selected permissions",
                    description:
                        "You’re about to permanently remove the selected system permissions. This action cannot be undone."
                ),
                selectedItems: names,
                action: SystemPermissionRoutes.remove.description,
                cancel: cancel,
                hiddenFields: ids.map { .init(name: "ids", value: $0) }
                    + [
                        .init(name: "_nonce", value: nonceToken),
                        .init(name: "returnTo", value: cancel),
                    ]
            )
        )
    }

    func renderErrorPage(
        info: String,
        message: String,
        cancel: String
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage system permissions",
            content: NewAdminStatusView(
                state: .init(title: info, message: message),
                icon: FeatherIcons.alertCircle(),
                action: NewAdminButton("Back", href: cancel, style: .secondary)
            )
        )
    }
}
