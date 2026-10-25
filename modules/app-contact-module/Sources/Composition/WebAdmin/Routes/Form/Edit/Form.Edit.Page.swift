import ContactApplication
import ContactModule
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension ContactModule.Form.Edit {
    struct Page: Component {
        struct State {
            let key: String
            let isReadOnly: Bool
            let form: ContactModule.Form.Editor.State
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: ContactModule.Form.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: state.isReadOnly
                                ? "Contact form" : "Edit contact form",
                            description: state.isReadOnly
                                ? "Review the contact form settings."
                                : "Update the contact form settings."
                        )
                    )
                )
                context.build(
                    ContactModule.Form.TabBar(
                        formId: state.key,
                        routes: state.routes,
                        active: .details
                    )
                )
                context.build(
                    AdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "Form configuration",
                            description:
                                "Configure the form fields and submission messages."
                        )
                    ) {
                        context.build(
                            ContactModule.Form.Editor(
                                state: state.form,
                                action: state.routes.formEditPath(state.key),
                                submitLabel: "Save changes",
                                isReadOnly: state.isReadOnly
                            )
                        )
                    }
                )
            }
            .class("cms-section")
        }
    }
}
