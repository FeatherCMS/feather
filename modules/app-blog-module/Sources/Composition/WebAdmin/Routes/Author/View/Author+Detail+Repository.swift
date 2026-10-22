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

extension Author.Detail {
    enum Repository {}
}

extension Author.Detail.Repository {
    protocol Interface: Sendable {
        func get(id: String) async throws -> Author.Detail.Model
    }
}
