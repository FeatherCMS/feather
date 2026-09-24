import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct AdminRemoveBlogAuthorLinkDefaultPresenter:
    AdminRemoveBlogAuthorLinkPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderRemovePage(
        menuId: String,
        item: NewAdminRemoveItemContext
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove blog author link",
            content: BlogAuthorLinkConfirmation(
                state: .init(
                    menuId: menuId,
                    id: item.id,
                    label: item.label,
                    breadcrumb: BlogAdminRoutes.authorLinksBreadcrumb(
                        RouterPath(menuId)
                    ),
                    nonceToken: nonceToken
                )
            )
        )
    }

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove blog author link",
            content: BlogAuthorLinkError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: BlogAdminRoutes.authorLinksBreadcrumb(
                        RouterPath(menuId)
                    )
                )
            )
        )
    }

}
