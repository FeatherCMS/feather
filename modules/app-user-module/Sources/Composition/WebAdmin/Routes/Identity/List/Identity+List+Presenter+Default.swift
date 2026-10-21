import FeatherModuleKit
import FeatherWebAdmin
import Hummingbird
import UserAdminAPI
import UserModule
import WebComponents

extension Identity.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Identity.Router.Routes

        func renderListPage(
            model: AdminListModel<
                Components.Schemas.UserIdentityQueryItemSchema
            >,
            permissions: Set<PermissionKey>,
            search: String?,
            role: String?
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "User identities",
                content: Identity.List.TableView(
                    routes: routes,
                    permissions: AdminListActions(permissions),
                    identities: model.items,
                    pageState: model.pageState,
                    search: search,
                    role: role
                )
            )
        }

        func renderErrorPage(error: Identity.List.Error) async throws
            -> HTMLResponse
        {
            let state: AdminStatusView.State
            switch error {
            case .unauthorized:
                state = .init(
                    title: "Session expired",
                    message: "Please sign in again to view user identities."
                )
            case .forbidden:
                state = .init(
                    title: "Forbidden",
                    message: "Your account cannot access user identities."
                )
            case .unavailable:
                state = .init(
                    title: "User identities unavailable",
                    message:
                        "The request could not be completed. Please try again."
                )
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "User identities",
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

        private func status(for error: Identity.List.Error)
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
