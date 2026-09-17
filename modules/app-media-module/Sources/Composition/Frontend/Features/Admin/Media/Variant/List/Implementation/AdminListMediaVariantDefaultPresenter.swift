import FeatherAdmin
import Hummingbird
import MediaAdminAPI
import WebComponents

struct AdminListMediaVariantDefaultPresenter: AdminListMediaVariantPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderListPage(
        model: NewAdminListModel<
            MediaAdminAPI.Components.Schemas.MediaVariantListItemSchema
        >,
        permissions: NewAdminListActions,
        search: String?
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Media variants",
            content: MediaVariantTable(
                state: .init(
                    permissions: permissions,
                    variants: model.items,
                    pageState: model.pageState,
                    search: search
                )
            )
        )
    }

    func renderErrorPage(error: AdminListMediaVariantError) async throws
        -> HTMLResponse
    {
        let state: NewAdminStatusView.State
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
                message: "The request could not be completed. Please try again."
            )
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Media variants",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    private func status(for error: AdminListMediaVariantError)
        -> HTTPResponse.Status
    {
        switch error {
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .unavailable: .serviceUnavailable
        }
    }
}
