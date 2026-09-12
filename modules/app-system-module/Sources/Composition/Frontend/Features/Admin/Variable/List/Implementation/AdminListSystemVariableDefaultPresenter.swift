import FeatherAdmin
import FeatherContracts
import Hummingbird
import SystemAdminAPI
import WebComponents

struct AdminListSystemVariableDefaultPresenter:
    AdminListSystemVariablePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    private var requestNotification: AdminNotification? {
        AdminNotificationFlash.notification(from: request)
    }

    func renderListPage(
        model: NewAdminListModel<
            Components.Schemas.SystemVariableListItemSchema
        >,
        permissions: Set<PermissionKey>,
        search: String?
    ) async throws -> HTMLResponse {
        let actions = NewAdminListActions(permissions)
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Variables",
            content: SystemVariableTable(
                state: .init(
                    permissions: actions,
                    variables: model.items,
                    pageState: model.pageState,
                    search: search,
                )
            ),

        )
    }

    func renderErrorPage(
        title: String,
        message: String
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Variables",
            content: NewAdminStatusView(
                state: .init(title: title, message: message),
                icon: FeatherIcons.alertCircle()
            ),

        )
    }

}
