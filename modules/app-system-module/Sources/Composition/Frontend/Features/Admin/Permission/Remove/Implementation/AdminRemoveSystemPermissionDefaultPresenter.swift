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
        fromDetails: Bool,
        fromEdit: Bool
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
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
                cancel: cancelURL(
                    ids: ids,
                    page: page,
                    search: search,
                    fromDetails: fromDetails,
                    fromEdit: fromEdit
                ),
                hiddenFields: ids.map { .init(name: "ids", value: $0) }
                    + [.init(name: "_nonce", value: nonceToken)]
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

    private func cancelURL(
        ids: [String],
        page: Int,
        search: String?,
        fromDetails: Bool,
        fromEdit: Bool
    ) -> String {
        if fromDetails, ids.count == 1 {
            return SystemPermissionRoutes.details(RouterPath(ids[0]))
                .description
        }
        if fromEdit, ids.count == 1 {
            return SystemPermissionRoutes.edit(RouterPath(ids[0])).description
        }
        return ListRemoveRedirect.location(
            path: SystemPermissionRoutes.list.description,
            page: page,
            search: search,
            title: nil,
            message: nil
        )
    }
}
