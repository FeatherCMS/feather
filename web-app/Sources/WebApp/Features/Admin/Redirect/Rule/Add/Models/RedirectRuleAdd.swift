import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct RedirectRuleAdd: Component {

    struct State {
        let form: RedirectRuleForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Add redirect rule")
            RedirectRuleForm(
                state: state.form,
                action: "/admin/redirect/rules/add/",
                submitLabel: "Add rule"
            )
        }
        .class("cms-section")
    }
}
