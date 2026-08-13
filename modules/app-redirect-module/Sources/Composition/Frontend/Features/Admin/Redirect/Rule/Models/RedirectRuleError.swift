import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import RedirectAdminAPI
import SGML
import WebStandards

struct RedirectRuleError: Component {

    struct State {
        let info: String
        let message: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1(state.info)
            P(state.message)
        }
        .class("cms-section")
    }
}
