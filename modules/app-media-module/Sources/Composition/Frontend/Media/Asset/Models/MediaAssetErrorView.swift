import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct MediaAssetErrorView: Leaf {
    let info: String
    let message: String
    let breadcrumb: AdminBreadcrumb.State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb).html()
            H1("Error")
            P { Strong(info) }
            P(message)
        }
        .class("cms-section")
    }
}
