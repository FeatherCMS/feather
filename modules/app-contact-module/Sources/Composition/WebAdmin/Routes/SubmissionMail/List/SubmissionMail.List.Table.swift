import ContactApplication
import ContactModule
import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.List {
    struct Table: Component {
        struct State {
            let id: String
            let mails: [ContactModule.Form.Email]
            let permissions: AdminListActions
            let breadcrumb: [AdminBreadcrumb.Link]
            let error: String?
            let routes: SubmissionMail.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Contact form emails",
                            description:
                                "Configure delivery messages for this contact form."
                        )
                    )
                )
                context.build(
                    ContactModule.Form.TabBar(
                        formId: state.id,
                        routes: state.routes.formRoutes,
                        active: .emails
                    )
                )
                context.build(
                    AdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "Emails",
                            description:
                                "Manage the notification emails configured for this contact form."
                        )
                    ) {
                        if let error = state.error {
                            P(error).class("admin-form__error")
                        }
                        context.build(
                            Table.Content(
                                id: state.id,
                                mails: state.mails,
                                permissions: state.permissions,
                                routes: state.routes
                            )
                        )
                    }
                )
            }
            .class("cms-section")
        }
    }
}
