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

struct AdminListBlogAuthorModel: Sendable {
    let items: [AdminListBlogAuthorItemModel]
    let total: Int
    let page: Int
    let pageSize: Int
}
