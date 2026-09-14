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

struct AdminViewBlogOverviewDefaultInteractor:
    AdminViewBlogOverviewInteractor
{
    func getOverview() async throws -> AdminViewBlogOverviewModel {
        .init(title: "Blog module")
    }
}
