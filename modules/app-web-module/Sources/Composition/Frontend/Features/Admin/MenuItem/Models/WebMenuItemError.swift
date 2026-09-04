import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebComponents
import WebBuilders

struct WebMenuItemError: Leaf {

    struct State {
        let info: String
        let message: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()

            H1(state.info)
            P(state.message)
        }
        .class("cms-section")
    }
}
