import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebStandards

struct BlogPostAssociationOptionsModel: Sendable {
    let authors: [BlogPostAssociationOptionModel]
    let tags: [BlogPostAssociationOptionModel]
}
