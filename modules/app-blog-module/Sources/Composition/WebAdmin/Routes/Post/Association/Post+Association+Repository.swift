import BlogAdminAPI
import BlogAppAPI
import BlogModule
import BlogWebShared
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

extension Post.Association {
    enum Repository {}
}

extension Post.Association.Repository {
    protocol Interface: Sendable {
        func loadOptions() async throws -> Post.Association.Options
    }
}
