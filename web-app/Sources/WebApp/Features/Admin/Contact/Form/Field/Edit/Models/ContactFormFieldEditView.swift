import HTML
import SGML
import WebStandards

struct ContactFormFieldEditView: Component {
    struct State {
        let formId: String
        let field: AdminContactFormFieldRow
        let error: String?
        let breadcrumb: AdminBreadcrumb.State
    }
    let state: State
    func content() -> some BasicTag {
        let basePath =
            state.formId.isEmpty
            ? "/admin/contact/fields"
            : "/admin/contact/forms/\(state.formId)/items"
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Edit contact form field")
            if let error = state.error { P(error).class("error") }
            ContactFormFieldForm(
                field: state.field,
                action: "\(basePath)/\(state.field.id)/edit/",
                submitLabel: "Save"
            )
        }
        .class("cms-section")
    }
}
