import BlogAdminAPI
import BlogAppAPI
import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct AdminRemoveBlogPostDefaultPresenter:
    AdminRemoveBlogPostPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderRemovePage(
        item: AdminRemoveItemContext
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderAdminDialog(
            request: request,
            context: context,
            title: AdminRemoveConfirmation.dialogTitle,
            content: BlogPostConfirmation(
                state: .init(
                    id: item.id,
                    source: item.label,
                    breadcrumb: BlogAdminRoutes.postsBreadcrumb,
                    nonceToken: nonceToken
                )
            ),
            size: .small
        )
    }

    func renderErrorPage(
        id: String,
        info: String,
        message: String
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Remove post",
            content: BlogPostError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: BlogAdminRoutes.postsBreadcrumb
                )
            )
        )
    }

}
