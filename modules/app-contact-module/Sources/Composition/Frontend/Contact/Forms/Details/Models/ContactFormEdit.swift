import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct ContactFormEdit: Leaf {
    struct State {
        let id: String
        let isEdited: Bool
        let form: ContactFormForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminContactFormTabs(formId: state.id, active: .details).renderHTML()
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("Edit contact form")
            if state.isEdited { P("Contact form edited successfully.") }
            ContactFormForm(
                state: state.form,
                action: "/admin/contact/forms/\(state.id)/edit/",
                submitLabel: "Save"
            ).renderHTML()
        }
        .class("cms-section")
    }

}
