import BlogAdminAPI
import BlogAppAPI
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

struct BlogPostAssociationOptionsModel: Sendable {
    let authors: [BlogPostAssociationOptionModel]
    let tags: [BlogPostAssociationOptionModel]
}
