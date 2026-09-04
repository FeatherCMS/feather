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

struct AdminGetBlogHomeDefaultInteractor: AdminGetBlogHomeInteractor {
    func getHome() async throws -> AdminGetBlogHomeModel {
        .init(title: "Blog module")
    }
}
