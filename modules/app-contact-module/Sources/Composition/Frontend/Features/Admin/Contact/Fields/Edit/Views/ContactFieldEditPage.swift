import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFieldEditPage: Component {
    struct State {
        let field: AdminContactFieldRow
        let error: String?
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit contact form field",
                        description: "Update this reusable contact form field."
                    )
                )
            )
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.build(
                ContactFieldForm(
                    field: state.field,
                    action: ContactAdminRoutes.fields
                        .appendingPath(RouterPath(state.field.id))
                        .appendingPath(RouterPath("edit")).description,
                    submitLabel: "Save changes"
                )
            )
        }
        .class("cms-section")
    }
}
