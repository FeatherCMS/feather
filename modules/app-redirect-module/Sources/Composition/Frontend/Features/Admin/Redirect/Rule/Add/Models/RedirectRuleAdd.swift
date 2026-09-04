import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import RedirectAdminAPI
import SGML
import WebComponents
import WebBuilders

struct RedirectRuleAdd: Leaf {

    struct State {
        let form: RedirectRuleForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1("Add redirect rule")
            RedirectRuleForm(
                state: state.form,
                action: "/admin/redirect/rules/add/",
                submitLabel: "Add rule"
            ).renderHTML()
        }
        .class("cms-section")
    }
}
