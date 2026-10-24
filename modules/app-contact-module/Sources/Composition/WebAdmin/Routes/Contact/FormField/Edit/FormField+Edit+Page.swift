import ContactApplication
import ContactModule
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension ContactModule.FormField.Edit {
    struct Page: Component {
        struct State {
            let field: FormField.Model
            let error: String?
            let fieldErrors: [String: String]
            let breadcrumb: [AdminBreadcrumb.Link]
            let action: String
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit contact form field",
                            description:
                                "Update this reusable contact form field."
                        )
                    )
                )
                context.build(
                    FormField.Form(
                        field: state.field,
                        action: state.action,
                        submitLabel: "Save changes",
                        error: state.error,
                        fieldErrors: state.fieldErrors
                    )
                )
            }
            .class("cms-section")
        }
    }
}
