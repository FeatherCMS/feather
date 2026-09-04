import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct ContactFieldEditView: Leaf {
    struct State {
        let field: AdminContactFieldRow
        let error: String?
        let breadcrumb: AdminBreadcrumb.State
    }
    let state: State
    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("Edit contact form field")
            if let error = state.error { P(error).class("error") }
            ContactFieldForm(
                field: state.field,
                action: "/admin/contact/fields/\(state.field.id)/edit/",
                submitLabel: "Save"
            ).renderHTML()
        }
        .class("cms-section")
    }
}
