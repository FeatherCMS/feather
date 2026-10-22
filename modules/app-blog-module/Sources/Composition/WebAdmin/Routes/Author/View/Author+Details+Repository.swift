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

extension Author.Details {
    enum Repository {}
}

extension Author.Details.Repository {
    protocol Interface: Sendable {
        func get(id: String) async throws -> Author.Details.Model
    }
}
