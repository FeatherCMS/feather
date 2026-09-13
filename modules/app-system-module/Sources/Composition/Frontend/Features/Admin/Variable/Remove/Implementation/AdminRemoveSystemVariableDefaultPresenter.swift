import FeatherAdmin
import Hummingbird
import WebComponents

struct AdminRemoveSystemVariableDefaultPresenter:
    AdminRemoveSystemVariablePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderErrorPage(
        info: String,
        message: String,
        cancel: String,
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage system variables",
            content: NewAdminStatusView(
                state: .init(title: info, message: message),
                icon: FeatherIcons.alertCircle(),
                action: NewAdminButton("Back", href: cancel, style: .secondary)
            )
        )
    }

    func renderRemoveConfirmation(
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
            path: SystemVariableRoutes.list.description,
            returnTo: returnTo
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage system variables",
            content: NewAdminConfirmation(
                breadcrumb: SystemVariableRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove selected variables",
                    description:
                        "You’re about to permanently remove the selected system variables. This action cannot be undone."
                ),
                selectedItems: names,
                action: SystemVariableRoutes.remove.description,
                cancel: cancel,
                hiddenFields: ids.map {
                    .init(name: "ids", value: $0)
                } + [
                    .init(name: "_nonce", value: nonceToken),
                    .init(name: "returnTo", value: cancel),
                ]
            )
        )
    }

}
