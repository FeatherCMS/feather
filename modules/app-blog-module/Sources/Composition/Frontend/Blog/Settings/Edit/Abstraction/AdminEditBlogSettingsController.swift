import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

protocol AdminEditBlogSettingsController: Sendable {
    func getEditBlogSettings(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditBlogSettings(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditBlogSettingsController {
    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/blog/settings/",
            use: getEditBlogSettings
        )
        router.post(
            "/admin/blog/settings/",
            use: postEditBlogSettings
        )
    }
}
