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

struct MediaProcessorErrorView: Leaf {
    let info: String
    let breadcrumb: AdminBreadcrumb.State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb).html()
            H1("Error")
            P(info)
        }
        .class("cms-section")
    }
}
