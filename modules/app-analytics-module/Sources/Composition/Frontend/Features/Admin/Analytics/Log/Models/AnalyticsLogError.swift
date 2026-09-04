import AnalyticsAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebComponents
import WebBuilders

struct AnalyticsLogError: Leaf {

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
