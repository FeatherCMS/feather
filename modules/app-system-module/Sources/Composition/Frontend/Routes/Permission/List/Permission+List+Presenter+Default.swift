import FeatherAdmin
import FeatherModuleKit
import HTML
import Hummingbird
import SystemModule
import WebBuilders
import WebComponents

extension WebAdmin.System.Permission.List.Presenter {
    struct Default:
        WebAdmin.System.Permission.List.Presenter.Interface
    {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: WebAdmin.System.Permission.Router.Routes

        func renderListPage(
            model: WebAdmin.System.Permission.List.Model,
            permissions: AdminListActions,
            search: String?
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Permissions",
                content: SystemPermissionTable(
                    state: .init(
                        permissions: permissions,
                        permissionsList: model.items,
                        pageState: .init(
                            page: model.page,
                            pageSize: model.pageSize,
                            total: model.total
                        ),
                        search: search,
                        routes: routes
                    )
                )
            )
        }

        func renderErrorPage(
            error: WebAdmin.System.Permission.List.Error
        ) async throws -> HTMLResponse {
            let state: AdminStatusView.State
            switch error {
            case .unauthorized:
                state = .init(
                    title: "Session expired",
                    message: "Please sign in again to view system permissions."
                )
            case .forbidden:
                state = .init(
                    title: "Forbidden",
                    message: "Your account cannot access system permissions."
                )
            case .unavailable:
                state = .init(
                    title: "System permissions unavailable",
                    message:
                        "The request could not be completed. Please try again."
                )
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Permissions",
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
            for error: WebAdmin.System.Permission.List.Error
        ) -> HTTPResponse.Status {
            switch error {
            case .unauthorized: .unauthorized
            case .forbidden: .forbidden
            case .unavailable: .serviceUnavailable
            }
        }

    }
}
