import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct MediaProcessorErrorView: Component {
    let info: String
    let breadcrumb: AdminBreadcrumb.State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: breadcrumb))
            H1("Error")
            P(info)
        }
        .class("cms-section")
    }
}
