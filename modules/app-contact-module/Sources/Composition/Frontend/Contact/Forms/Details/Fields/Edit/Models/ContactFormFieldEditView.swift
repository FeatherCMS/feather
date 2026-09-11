import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct ContactFormFieldEditView: Component {
    struct State {
        let formId: String
        let field: AdminContactFormFieldRow
        let error: String?
        let breadcrumb: AdminBreadcrumb.State
    }
    let state: State
    func html(context: inout RenderContext) -> some BasicTag {
        let basePath = "/admin/contact/forms/\(state.formId)/fields"
        return Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("Edit contact form field")
            if let error = state.error { P(error).class("error") }
            context.render(ContactFormFieldForm(
                field: state.field,
                action: "\(basePath)/\(state.field.id)/edit/",
                submitLabel: "Save"
            ))
        }
        .class("cms-section")
    }
}
