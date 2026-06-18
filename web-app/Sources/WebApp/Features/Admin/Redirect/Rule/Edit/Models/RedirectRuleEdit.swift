import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct RedirectRuleEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: RedirectRuleForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Edit redirect rule")
            if state.isEdited { P("Redirect rule edited successfully.") }
            RedirectRuleForm(
                state: state.form,
                action: "/admin/redirect/rules/\(state.id)/edit/",
                submitLabel: "Edit rule",
                removeHref: "/admin/redirect/rules/\(state.id)/remove/",
                removeLabel: "Remove rule"
            )
        }
        .class("cms-section")
    }
}
