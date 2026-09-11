import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebComponents
import WebBuilders

struct WebMenuError: Component {

    struct State {
        let info: String
        let message: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1(state.info)
            P(state.message)
        }
        .class("cms-section")
    }
}
