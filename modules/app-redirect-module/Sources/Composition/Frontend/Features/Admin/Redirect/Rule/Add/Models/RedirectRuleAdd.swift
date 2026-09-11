import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import RedirectAdminAPI
import SGML
import WebBuilders
import WebComponents

struct RedirectRuleAdd: Component {

    struct State {
        let form: RedirectRuleForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Add redirect rule")
            context.render(
                RedirectRuleForm(
                    state: state.form,
                    action: "/admin/redirect/rules/add/",
                    submitLabel: "Add rule"
                )
            )
        }
        .class("cms-section")
    }
}
