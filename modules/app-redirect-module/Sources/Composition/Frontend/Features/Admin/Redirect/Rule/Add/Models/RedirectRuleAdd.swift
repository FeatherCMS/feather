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

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()

            H1("Add redirect rule")
            RedirectRuleForm(
                state: state.form,
                action: "/admin/redirect/rules/add/",
                submitLabel: "Add rule"
            ).html()
        }
        .class("cms-section")
    }
}
