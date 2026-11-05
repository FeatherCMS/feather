import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaAdminAPI
import MediaModule
import WebComponents

extension Variant.Processor.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Variant.Router.Routes

        func renderAddPage(variantId: String) async throws -> HTMLResponse {
            let nonce = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Add media variant processor",
                content: Variant.Processor.Add.Page(
                    variantId: variantId,
                    form: Variant.Processor.Form(
                        processor: nil,
                        action: routes.processorAddPath(variantId),
                        nonceToken: nonce
                    ),
                    routes: routes
                )
            )
        }

        func renderListPage(
            variantId: String,
            model: AdminListModel<
                MediaAdminAPI.Components.Schemas
                    .MediaVariantProcessorQueryItemSchema
            >,
            permissions: AdminListActions,
            search: String?
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Media variant processors",
                content: Variant.Processor.List.Page(
                    variantId: variantId,
                    processors: model.items,
                    pageState: model.pageState,
                    search: search,
                    permissions: permissions,
                    routes: routes
                )
            )
        }

        func renderErrorPage(error: Variant.Processor.List.Error)
            async throws -> HTMLResponse
        {
            let state: AdminStatusView.State
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
                    message:
                        "The request could not be completed. Please try again."
                )
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Media variant processors",
                content: AdminStatusView(
                    state: state,
                    icon: FeatherIcons.alertCircle(),
                    action: AdminButton(
                        "Back",
                        href: routes.list.path,
                        style: .secondary
                    )
                )
            )
            return HTMLResponse(
                content: page.content,
                status: status(for: error)
            )
        }

        private func status(for error: Variant.Processor.List.Error)
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
}
