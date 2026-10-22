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

extension Tag.View {
    enum Interactor {}
}

extension Tag.View.Interactor {
    protocol Interface: Sendable {
        func execute(_ input: Tag.View.Model) async throws -> Tag.Details.Model
    }
}
