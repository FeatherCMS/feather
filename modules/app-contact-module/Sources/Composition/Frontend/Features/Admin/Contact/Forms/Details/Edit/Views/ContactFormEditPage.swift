import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormEditPage: Component {
    struct State {
        let id: String
        let isEdited: Bool
        let isReadOnly: Bool
        let form: ContactFormForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminContactFormTabs(formId: state.id, active: .details))
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(NewAdminPageHeader(state: .init(title: state.isReadOnly ? "Contact form" : "Edit contact form", description: state.isReadOnly ? "Review form settings and field order." : "Update form settings and field order.")))
            if state.isEdited && !state.isReadOnly {
                context.render(NewAdminNotification(notification: .init(title: "Form updated", message: "Contact form updated successfully.")))
            }
            context.render(ContactFormForm(state: state.form, action: ContactAdminRoutes.formEdit(RouterPath(state.id)).description, submitLabel: "Save changes", isReadOnly: state.isReadOnly))
        }.class("cms-section")
    }
}
