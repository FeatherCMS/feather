import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import RedirectAdminAPI
import SGML
import WebComponents
import WebBuilders

struct RedirectRuleEdit: Leaf {

    struct State {
        let id: String
        let isEdited: Bool
        let form: RedirectRuleForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()

            H1("Edit redirect rule")
            if state.isEdited { P("Redirect rule edited successfully.") }
            RedirectRuleForm(
                state: state.form,
                action: "/admin/redirect/rules/\(state.id)/edit/",
                submitLabel: "Edit rule",
                removeHref: "/admin/redirect/rules/\(state.id)/remove/",
                removeLabel: "Remove rule"
            ).html()
        }
        .class("cms-section")
    }
}
