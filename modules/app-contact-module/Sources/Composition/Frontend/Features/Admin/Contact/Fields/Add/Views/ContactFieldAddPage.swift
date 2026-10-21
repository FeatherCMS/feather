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
        let allowedValues: [String]
        let isRequired: Bool
        let position: String
        let formKey: String?
        let error: String?
        let fieldErrors: [String: String]
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        let fieldForm = ContactFieldForm(
            field: .init(
                id: "",
                key: state.key,
                type: state.type,
                label: state.label,
                allowedValues: state.allowedValues,
                isRequired: state.isRequired,
                position: state.position
            ),
            action: NewAdminLocation.url(
                path: ContactAdminRoutes.fieldAdd.description,
                queryItems: state.formKey.map { [("form", $0)] } ?? []
            ),
            submitLabel: "Add field",
            error: state.error,
            fieldErrors: state.fieldErrors
        )
        return Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .primary(
                        title: state.formKey == nil
                            ? "Add contact form field"
                            : "Add field to contact form",
                        description: state.formKey == nil
                            ? "Create a reusable field for contact forms."
                            : "Create a reusable field and add it to this contact form."
                    )
                )
            )
            if let formKey = state.formKey {
                context.build(
                    AdminContactFormTabs(formId: formKey, active: .fields)
                )
                context.build(
                    NewAdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "Contact form field",
                            description:
                                "Configure the field being added to this form."
                        )
                    ) {
                        context.build(fieldForm)
                    }
                )
            }
            else {
                context.build(fieldForm)
            }
        }
        .class("cms-section")
    }
}
