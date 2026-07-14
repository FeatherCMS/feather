import HTML
import SGML
import WebStandards

struct ContactFormEdit: Component {
    struct State {
        let id: String
        let isEdited: Bool
        let form: ContactFormForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminContactFormTabs(formId: state.id, active: .details)
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Edit contact form")
            if state.isEdited { P("Contact form edited successfully.") }
            ContactFormForm(state: state.form, action: "/admin/contact/forms/\(state.id)/edit/", submitLabel: "Save")
        }.class("cms-section")
    }
}
