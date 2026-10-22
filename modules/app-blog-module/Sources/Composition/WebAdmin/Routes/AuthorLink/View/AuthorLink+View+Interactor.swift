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

extension AuthorLink.View {
    enum Interactor {}
}

extension AuthorLink.View.Interactor {
    protocol Interface: Sendable {
        func execute(_ input: AuthorLink.View.Model) async throws
            -> AuthorLink.Detail.Model
    }
}
