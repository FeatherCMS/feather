import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaAdminAPI
import MediaModule
import WebComponents

extension Variant.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Variant.Router.Routes

        func renderListPage(
            model: AdminListModel<
                MediaAdminAPI.Components.Schemas.MediaVariantQueryItemSchema
            >,
            permissions: AdminListActions,
            search: String?
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Media variants",
                content: MediaVariantTable(
                    state: .init(
                        permissions: permissions,
                        variants: model.items,
                        pageState: model.pageState,
                        search: search,
                        routes: routes
                    )
                )
            )
        }

        func renderErrorPage(error: Variant.List.Error) async throws
            -> HTMLResponse
        {
            let state: AdminStatusView.State
            switch error {
            case .unauthorized:
                state = .init(
                    title: "Session expired",
                    message: "Please sign in again to view media variants."
                )
            case .forbidden:
                state = .init(
                    title: "Forbidden",
                    message: "Your account cannot access media variants."
                )
            case .unavailable:
                state = .init(
                    title: "Media variants unavailable",
                    message:
                        "The request could not be completed. Please try again."
                )
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Media variants",
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

        private func status(for error: Variant.List.Error)
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
