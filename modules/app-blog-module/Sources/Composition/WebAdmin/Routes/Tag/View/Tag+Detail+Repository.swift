import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Tag.Detail {
    enum Repository {}
}

extension Tag.Detail.Repository {
    protocol Interface: Sendable {
        func get(id: String) async throws -> Tag.Detail.Model
    }
}
