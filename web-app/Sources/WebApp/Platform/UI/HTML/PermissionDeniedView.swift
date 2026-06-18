import HTML
import SGML
import WebStandards

struct PermissionDeniedView: Component {

    struct State {
        let info: String
        let message: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("No permission")
            P(state.info).class("error")
            P(state.message)
        }
        .class("cms-section")
    }
}
