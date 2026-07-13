import HTML
import SGML
import WebStandards

struct ContactFormAdd: Component {
    struct State {
        let form: ContactFormForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Add contact form")
            ContactFormForm(state: state.form, action: "/admin/contact/forms/add/", submitLabel: "Add form")
        }.class("cms-section")
    }
}
