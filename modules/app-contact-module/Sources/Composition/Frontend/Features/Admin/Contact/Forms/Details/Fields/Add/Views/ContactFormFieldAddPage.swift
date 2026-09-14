import FeatherAdmin
import ContactContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormFieldAddPage: Component {
    struct State {
        let formId: String
        let key: String
        let type: String
        let label: String
        let allowedValues: String
        let isRequired: Bool
        let position: String
        let error: String?
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }
    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminContactFormTabs(formId: state.formId, active: .details))
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(NewAdminPageHeader(state: .init(title: "Add contact form field", description: "Add a field to this contact form.")))
            if let error = state.error { P(error).class("new-admin-form__error") }
            context.render(ContactFormFieldForm(
                field: .init(id: "", formId: state.formId, key: state.key, type: state.type, label: state.label, allowedValues: state.allowedValues, isRequired: state.isRequired, position: state.position),
                action: ContactAdminRoutes.formFieldAdd(RouterPath(state.formId)).description,
                submitLabel: "Add field"
            ))
        }.class("cms-section")
    }
}
