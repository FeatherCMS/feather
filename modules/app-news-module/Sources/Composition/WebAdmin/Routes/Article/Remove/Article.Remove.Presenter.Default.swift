import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Article.Remove.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Article.Router.Routes

        func renderRemoveConfirmation(
            item: Article.Detail.Model
        ) async throws -> Response {
            let nonce = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return
                try await renderingEngine.renderAdminDialog(
                    request: request,
                    context: context,
                    title: AdminRemoveConfirmation.dialogTitle,
                    content: AdminRemoveConfirmation(
                        header: .primary(
                            title: "Remove news article",
                            description: "This action cannot be undone."
                        ),
                        selectedItems: [item.title],
                        action: routes.removePath(item.id),
                        nonceToken: nonce,
                        hiddenFields: [.init(name: "id", value: item.id)]
                    ),
                    size: .small
                )
                .response(from: request, context: context)
        }

        func renderError(_ message: String) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "News article",
                content: News.Error.Page(
                    breadcrumb: routes.breadcrumb,
                    title: "News article unavailable",
                    message: message
                )
            )
        }

        func renderRemoved() -> Response {
            AdminNotification.redirect(
                to: routes.list.path,
                notification: .init(
                    title: "Removed",
                    message: "News article removed successfully."
                )
            )
        }
    }
}
