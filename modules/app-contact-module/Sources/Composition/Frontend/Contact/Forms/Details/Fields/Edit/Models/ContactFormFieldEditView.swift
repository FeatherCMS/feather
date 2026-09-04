import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct ContactFormFieldEditView: Leaf {
    struct State {
        let formId: String
        let field: AdminContactFormFieldRow
        let error: String?
        let breadcrumb: AdminBreadcrumb.State
    }
    let state: State
    func html() -> some BasicTag {
        let basePath = "/admin/contact/forms/\(state.formId)/fields"
        return Section {
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1("Edit contact form field")
            if let error = state.error { P(error).class("error") }
            ContactFormFieldForm(
                field: state.field,
                action: "\(basePath)/\(state.field.id)/edit/",
                submitLabel: "Save"
            ).html()
        }
        .class("cms-section")
    }
}
