import ContactApplication
import ContactModule
import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension ContactModule.FormField.List {
    struct Page: Component {
        struct State {
            let fields: [FormField.Model]
            let forms: [FormField.List.FormOption]
            let formKey: String?
            let pageState: AdminListPageState
            let search: String
            let error: String?
            let permissions: AdminListActions
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: FormField.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Contact form fields",
                            description: "Manage reusable contact form fields."
                        )
                    )
                )
                if let error = state.error {
                    P(error).class("admin-form__error")
                }
                context.build(
                    FormField.List.Page.Content(
                        fields: state.fields,
                        forms: state.forms,
                        formKey: state.formKey,
                        pageState: state.pageState,
                        search: state.search,
                        permissions: state.permissions,
                        routes: state.routes
                    )
                )
            }
            .class("cms-section")
        }
    }
}
