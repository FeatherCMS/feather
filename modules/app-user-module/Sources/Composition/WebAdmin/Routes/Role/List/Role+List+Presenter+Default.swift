import FeatherModuleKit
import FeatherWebShared
import FeatherWebAdmin
import Hummingbird
import UserAdminAPI
import UserModule

extension Role.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Role.Router.Routes

        func renderListPage(
            model: AdminListModel<Components.Schemas.UserRoleQueryItemSchema>,
            permissions: Set<PermissionKey>,
            search: String?
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "User roles",
                content: Role.List.TableView(
                    routes: routes,
                    permissions: AdminListActions(permissions),
                    roles: model.items,
                    pageState: model.pageState,
                    search: search
                )
            )
        }

        func renderErrorPage(error: Role.List.Error) async throws
            -> HTMLResponse
        {
            let state: AdminStatusView.State
            switch error {
            case .unauthorized:
                state = .init(
                    title: "Session expired",
                    message: "Please sign in again to view user roles."
                )
            case .forbidden:
                state = .init(
                    title: "Forbidden",
                    message: "Your account cannot access user roles."
                )
            case .unavailable:
                state = .init(
                    title: "User roles unavailable",
                    message:
                        "The request could not be completed. Please try again."
                )
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "User roles",
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

        private func status(for error: Role.List.Error)
            -> HTTPResponse.Status
        {
            switch error {
            case .unauthorized: .unauthorized
            case .forbidden: .forbidden
            case .unavailable: .serviceUnavailable
            }
        }
    }
}
