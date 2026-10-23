import ContactModule
import FeatherWebAdmin
import FeatherWebShared
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
        let breadcrumb: [AdminBreadcrumb.Link]
        let routes: Contact.Router.Routes
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
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
            context.build(
                AdminRelationshipGroup(
                    pageHeader: .secondary(
                        title: "Fields",
                        description:
                            "Select fields and drag them to set the order shown to visitors."
                    )
                ) {
                    if state.canAddField {
                        context.build(
                            AdminListToolbar {
                                context.build(
                                    AdminButton(
                                        "Add field",
                                        href: AdminLocation.url(
                                            path: state.routes.fieldAdd.path,
                                            queryItems: [("form", state.key)]
                                        )
                                    )
                                )
                            }
                        )
                    }
                    context.build(
                        ContactFormForm(
                            state: state.form,
                            action: state.routes.formFieldsPath(state.key),
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
