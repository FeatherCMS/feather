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

struct AdminEditBlogSettingsModel: Sendable {
    let postListPath: String
    let authorListPath: String
    let tagListPath: String
    let postPathPrefix: String
    let authorPathPrefix: String
    let tagPathPrefix: String
    let hasMissingVariables: Bool
}
