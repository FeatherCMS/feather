import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Settings.Edit {
    struct Model: Sendable {
        let postListPath: String
        let authorListPath: String
        let tagListPath: String
        let postPathPrefix: String
        let authorPathPrefix: String
        let tagPathPrefix: String
        let hasMissingVariables: Bool
    }
}
