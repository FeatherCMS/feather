import Foundation
import ContactApplication
import ContactModule
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension ContactModule.FormField.Add {
    struct Page: Component {
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
            let addPath: String
            let formRoutes: ContactModule.Form.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            let fieldForm = fieldForm(context: &context)
            return Section {
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
                        ContactModule.Form.TabBar(
                            formId: formKey,
                            routes: state.formRoutes,
                            active: .fields
                        )
                    )
                    context.build(
                        AdminRelationshipGroup(
                            pageHeader: .secondary(
                                title: "Contact form field",
                                description:
                                    "Configure the field being added to this form."
                            )
                        ) {
                            fieldForm
                        }
                    )
                }
                else {
                    fieldForm
                }
            }
            .class("cms-section")
        }

        private func fieldForm(context: inout BuilderContext) -> HTML.Form {
            let action = AdminLocation.url(
                path: state.addPath,
                queryItems: state.formKey.map {
                    [.init(name: "form", value: $0)]
                } ?? []
            )
            let form = AdminForm(action: action) {
                context.build(
                    AdminFormFieldInput(
                        state: .init(
                            name: "key",
                            label: "Key",
                            value: state.key,
                            error: state.fieldErrors["key"],
                            isRequired: true
                        )
                    )
                )
                context.build(
                    AdminFormFieldSelect(
                        state: .init(
                            name: "type",
                            label: "Type",
                            value: state.type,
                            options: [
                                .init(label: "Text", value: "text"),
                                .init(label: "Textarea", value: "textarea"),
                                .init(label: "Select", value: "select"),
                                .init(label: "Radio", value: "radio"),
                                .init(label: "Toggle", value: "toggle"),
                                .init(label: "Hidden", value: "hidden"),
                            ],
                            error: state.fieldErrors["type"],
                            isRequired: true
                        )
                    )
                )
                context.build(
                    AdminFormFieldInput(
                        state: .init(
                            name: "label",
                            label: "Label",
                            value: state.label,
                            error: state.fieldErrors["label"],
                            isRequired: true
                        )
                    )
                )
                context.build(
                    AdminFormFieldMultiInput(
                        state: .init(
                            name: "allowedValues[]",
                            label: "Allowed values",
                            values: state.allowedValues,
                            error: state.fieldErrors["allowedValues"]
                        )
                    )
                )
                context.build(
                    AdminFormFieldCheckbox(
                        state: .init(
                            name: "isRequired",
                            label: "Field validation",
                            checkboxLabel: "Require this field",
                            isChecked: state.isRequired
                        )
                    )
                )
                context.build(
                    AdminFormFieldInput(
                        state: .init(
                            name: "position",
                            label: "Position",
                            value: state.position
                        )
                    )
                )
                if let error = state.error {
                    P(error).class("admin-form__error")
                }
                Div { context.build(AdminSubmitButton("Create field")) }
                    .class("admin-form__actions")
            }
            return context.build(form)
        }
    }
}
