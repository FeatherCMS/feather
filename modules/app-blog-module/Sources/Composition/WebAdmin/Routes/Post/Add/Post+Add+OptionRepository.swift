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

extension Post.Add {
    enum OptionRepository {}
}

extension Post.Add.OptionRepository {
    protocol Interface: Sendable {
        func loadOptions() async throws -> BlogPostAssociationOptionsModel
    }
}
