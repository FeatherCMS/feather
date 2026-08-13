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
import WebStandards

protocol AdminGetBlogHomeController: Sendable {

    func getHome(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetBlogHomeController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/",
            use: getHome
        )
    }
}
