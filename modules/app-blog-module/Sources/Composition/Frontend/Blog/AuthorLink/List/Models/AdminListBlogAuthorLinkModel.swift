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

struct AdminListBlogAuthorLinkModel: Sendable {
    let items: [BlogAdminAPI.Components.Schemas.BlogAuthorLinkListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
