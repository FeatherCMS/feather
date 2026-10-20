import FeatherAdmin
import FeatherModuleKit
import Hummingbird
import SystemAdminAPI
import SystemModule
import WebComponents

extension WebAdmin.System.Variable.List.Presenter {
    struct Default:
        WebAdmin.System.Variable.List.Presenter.Interface
    {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: WebAdmin.System.Variable.Router.Routes

        func renderListPage(
            model: AdminListModel<
                Components.Schemas.SystemVariableListItemSchema
            >,
            permissions: Set<PermissionKey>,
            search: String?
        ) async throws -> HTMLResponse {
            let actions = AdminListActions(permissions)
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Variables",
                content: SystemVariableTable(
                    state: .init(
                        permissions: actions,
                        variables: model.items,
                        pageState: model.pageState,
                        search: search,
                        routes: routes
                    )
                ),

            )
        }

        func renderErrorPage(
            error: WebAdmin.System.Variable.List.Error
        ) async throws -> HTMLResponse {
            let state: AdminStatusView.State

            switch error {
            case .unauthorized:
                state = .init(
                    title: "Session expired",
                    message: "Please sign in again to view system variables."
                )
            case .forbidden:
                state = .init(
                    title: "Forbidden",
                    message: "Your account cannot access system variables."
                )
            case .unavailable:
                state = .init(
                    title: "System variables unavailable",
                    message:
                        "The request could not be completed. Please try again."
                )
            }

            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Variables",
                content: AdminStatusView(
                    state: state,
                    icon: FeatherIcons.alertCircle()
                )
            )
            return HTMLResponse(
                content: page.content,
                status: status(for: error)
            )
        }

        private func status(
            for error: WebAdmin.System.Variable.List.Error
        ) -> HTTPResponse.Status {
            switch error {
            case .unauthorized:
                .unauthorized
            case .forbidden:
                .forbidden
            case .unavailable:
                .serviceUnavailable
            }
        }

    }
}
