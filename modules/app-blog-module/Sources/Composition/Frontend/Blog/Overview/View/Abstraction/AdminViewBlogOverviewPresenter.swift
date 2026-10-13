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

protocol AdminViewBlogOverviewPresenter: Sendable {

    func renderOverview(
        model: AdminViewBlogOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
