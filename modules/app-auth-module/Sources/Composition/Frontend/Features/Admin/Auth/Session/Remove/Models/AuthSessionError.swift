import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct AuthSessionError: Leaf {

    struct State {
        let info: String
        let message: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1(state.info)
            P(state.message)
        }
        .class("cms-section")
    }
}
