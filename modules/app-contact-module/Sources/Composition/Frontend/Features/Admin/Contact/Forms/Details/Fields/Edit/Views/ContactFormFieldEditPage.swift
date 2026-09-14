import ContactContracts
import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormFieldEditPage: Component {
    struct State {
        let formId: String
        let field: AdminContactFormFieldRow
        let error: String?
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }
    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(
                AdminContactFormTabs(formId: state.formId, active: .details)
            )
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit contact form field",
                        description: "Update this form field."
                    )
                )
            )
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.render(
                ContactFormFieldForm(
                    field: state.field,
                    action:
                        ContactAdminRoutes.formFieldEdit(
                            formID: RouterPath(state.formId),
                            fieldID: RouterPath(state.field.id)
                        )
                        .description,
                    submitLabel: "Save changes"
                )
            )
        }
        .class("cms-section")
    }
}
