import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFieldAddPage: Component {
    struct State {
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

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add contact form field",
                        description:
                            "Create a reusable field for contact forms."
                    )
                )
            )
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.build(
                ContactFieldForm(
                    field: .init(
                        id: "",
                        key: state.key,
                        type: state.type,
                        label: state.label,
                        allowedValues: state.allowedValues,
                        isRequired: state.isRequired,
                        position: state.position
                    ),
                    action: ContactAdminRoutes.fieldAdd.description,
                    submitLabel: "Add field"
                )
            )
        }
        .class("cms-section")
    }
}
