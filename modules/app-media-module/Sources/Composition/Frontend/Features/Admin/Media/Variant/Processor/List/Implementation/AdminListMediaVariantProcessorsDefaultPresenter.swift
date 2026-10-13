import FeatherAdmin
import Hummingbird
import MediaAdminAPI
import MediaContracts
import WebComponents

struct AdminListMediaVariantProcessorsDefaultPresenter:
    AdminListMediaVariantProcessorsPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(variantId: String) async throws -> HTMLResponse {
        let nonce = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add media variant processor",
            content: MediaVariantProcessorAddPage(
                variantId: variantId,
                form: MediaVariantProcessorFormView(
                    processor: nil,
                    action:
                        MediaVariantRoutes.processorAdd(RouterPath(variantId))
                        .description,
                    nonceToken: nonce
                )
            )
        )
    }

    func renderListPage(
        variantId: String,
        model: NewAdminListModel<
            MediaAdminAPI.Components.Schemas.MediaVariantProcessorListItemSchema
        >,
        permissions: NewAdminListActions,
        search: String?
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Media variant processors",
            content: MediaVariantProcessorsPage(
                variantId: variantId,
                processors: model.items,
                pageState: model.pageState,
                search: search,
                permissions: permissions
            )
        )
    }

    func renderErrorPage(error: AdminListMediaVariantProcessorsError)
        async throws -> HTMLResponse
    {
        let state: NewAdminStatusView.State
        switch error {
        case .notFound:
            state = .init(
                title: "Media variant not found",
                message: "This variant may have been removed."
            )
        case .unauthorized:
            state = .init(
                title: "Session expired",
                message: "Please sign in again."
            )
        case .forbidden:
            state = .init(
                title: "Forbidden",
                message: "Your account cannot access variant processors."
            )
        case .unavailable:
            state = .init(
                title: "Processors unavailable",
                message: "The request could not be completed. Please try again."
            )
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Media variant processors",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle(),
                action: NewAdminButton(
                    "Back",
                    href: MediaVariantRoutes.list.description,
                    style: .secondary
                )
            )
        )
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    private func status(for error: AdminListMediaVariantProcessorsError)
        -> HTTPResponse.Status
    {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .unavailable: .serviceUnavailable
        }
    }
}
