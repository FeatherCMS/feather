import HTML
import SGML
import WebStandards

struct ContactFormItemEditView: Component {
    struct State {
        let formId: String
        let item: AdminContactFormItemRow
        let error: String?
        let breadcrumb: AdminBreadcrumb.State
    }
    let state: State
    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Edit contact form field")
            if let error = state.error { P(error).class("error") }
            ContactFormItemForm(
                item: state.item,
                action:
                    "/admin/contact/forms/\(state.formId)/items/\(state.item.id)/edit/",
                submitLabel: "Save"
            )
        }
        .class("cms-section")
    }
}
