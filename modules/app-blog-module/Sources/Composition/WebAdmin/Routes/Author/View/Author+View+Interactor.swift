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

extension Author.View {
    enum Interactor {}
}

extension Author.View.Interactor {
    protocol Interface: Sendable {
        func execute(entity: Author.View.Model) async throws
            -> Author.Detail.Model
    }
}
