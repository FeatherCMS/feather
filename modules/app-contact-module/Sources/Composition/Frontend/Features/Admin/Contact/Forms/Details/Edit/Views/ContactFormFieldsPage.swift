import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormFieldsPage: Component {
    struct State {
        let key: String
        let isReadOnly: Bool
        let canAddField: Bool
        let form: ContactFormForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .primary(
                        title: "Contact form fields",
                        description:
                            "Choose the fields used by this form and arrange their order."
                    )
                )
            )
            context.build(
                AdminContactFormTabs(formId: state.key, active: .fields)
            )
            if state.canAddField {
                context.build(
                    NewAdminListToolbar {
                        context.build(
                            NewAdminButton(
                                "Add field",
                                href: NewAdminLocation.url(
                                    path: ContactAdminRoutes.fieldAdd
                                        .description,
                                    queryItems: [("form", state.key)]
                                )
                            )
                        )
                    }
                )
            }
            context.build(
                NewAdminRelationshipGroup(
                    pageHeader: .secondary(
                        title: "Fields",
                        description:
                            "Select fields and drag them to set the order shown to visitors."
                    )
                ) {
                    context.build(
                        ContactFormForm(
                            state: state.form,
                            action:
                                ContactAdminRoutes.formFields(
                                    RouterPath(state.key)
                                )
                                .description,
                            submitLabel: "Save fields",
                            isReadOnly: state.isReadOnly,
                            mode: .fields
                        )
                    )
                }
            )
        }
        .class("cms-section")
    }
}
