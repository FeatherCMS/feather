import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension ContactModule.Form.Edit.Fields {
    struct Page: Component {
        struct State {
            let key: String
            let isReadOnly: Bool
            let canAddField: Bool
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
                            title: "Edit contact form",
                            description:
                                "Update the contact form settings."
                        )
                    )
                )
                context.build(
                    ContactModule.Form.TabBar(
                        formId: state.key,
                        routes: state.routes,
                        active: .fields
                    )
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
                                                path: state.routes.fieldAdd
                                                    .path,
                                                queryItems: [
                                                    .init(
                                                        name: "form",
                                                        value: state.key
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                }
                            )
                        }
                        context.build(
                            ContactModule.Form.Editor(
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
}
