import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct ContactFieldEditView: Component {
    struct State {
        let field: AdminContactFieldRow
        let error: String?
        let breadcrumb: AdminBreadcrumb.State
    }
    let state: State
    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Edit contact form field")
            if let error = state.error { P(error).class("error") }
            ContactFieldForm(
                field: state.field,
                action: "/admin/contact/fields/\(state.field.id)/edit/",
                submitLabel: "Save"
            )
        }
        .class("cms-section")
    }
}
