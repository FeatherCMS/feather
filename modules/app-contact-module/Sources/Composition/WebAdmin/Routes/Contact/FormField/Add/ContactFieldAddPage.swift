import FeatherWebAdmin
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
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
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
