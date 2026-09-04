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
import WebComponents
import WebBuilders

struct BlogAuthorLinkDetailsModel: Sendable {
    let id: String
    let menuId: String
    let label: String
    let url: String
    let priority: Int
    let isBlank: Bool
    let permission: String
    let notes: String
}
