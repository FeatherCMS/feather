import CSS
import FeatherWebAdmin
import Foundation
import HTML
import SGML
import WebBuilders
import WebComponents
import WebModule

extension Page.Edit.Template {
    struct ListEditor: WebComponents.Component {
        let name: String
        let title: String
        let itemKind: WebModule.Template.Field.Kind
        let editor: WebModule.Template.Field.Editor
        let required: Bool
        let values: [WebModule.Template.Value]

        func selectors() -> [any CSS.Selector] {
            [
                Class("template-list-editor") {
                    Display(.flex)
                    FlexDirection(.column)
                    Gap(14.px)
                },
                Class("template-list-editor__items") {
                    Display(.flex)
                    FlexDirection(.column)
                    Gap(12.px)
                },
                Class("template-list-editor__item") {
                    Display(.flex)
                    FlexDirection(.column)
                    Gap(14.px)
                    Padding(14.px)
                    Border(1.px, .solid, .variable(TokenKey.Colors.Materials.Tertiary.border))
                    BorderRadius(8.px)
                },
                Class("template-list-editor__item-header") {
                    Display(.flex)
                    AlignItems(.center)
                    JustifyContent(.spaceBetween)
                    Gap(12.px)
                },
                Custom(".template-list-editor__item-header h3") {
                    Margin(0.px)
                    FontSize(1.rem)
                },
                Class("template-list-editor__fields") {
                    Display(.grid)
                    GridTemplateColumns(.tracks([.fraction(1.fr)]))
                    Gap(14.px)
                },
                Class("template-list-editor__actions") {
                    Display(.flex)
                    JustifyContent(.flexStart)
                },
                Class("template-list-editor__prototype") {
                    Display(.none)
                },
                Class("template-list-editor__value") {
                    Display(.none)
                },
            ]
        }

        func html(context: inout BuilderContext) -> Div {
            Div {
                Div {
                    for index in values.indices {
                        itemCard(
                            index: index,
                            value: values[index],
                            context: &context
                        )
                    }
                    itemCard(
                        index: values.count,
                        value: emptyValue(for: itemKind),
                        isPrototype: true,
                        context: &context
                    )
                }
                .class("template-list-editor__items")

                Textarea(encodedValues)
                    .name(name)
                    .class("template-list-editor__value")

                Div {
                    Button("Add \(singularTitle)")
                        .type(.button)
                        .class("button", "secondary")
                        .data("template-list-add", "true")
                }
                .class("template-list-editor__actions")

                Div {}
                    .class("template-list-editor__status")
                    .role("status")
                    .ariaLive(.polite)
            }
            .class("template-list-editor")
            .data("template-list-editor", "true")
            .data("template-list-name", name)
            .data("template-list-title", singularTitle)
            .data("template-list-required", required ? "true" : "false")
        }

        private func itemCard(
            index: Int,
            value: WebModule.Template.Value,
            isPrototype: Bool = false,
            context: inout BuilderContext
        ) -> Div {
            Div {
                Div {
                    H3("\(singularTitle) \(index + 1)")
                    Button("Remove")
                        .type(.button)
                        .class("button", "destructive")
                        .data("template-list-remove", "true")
                }
                .class("template-list-editor__item-header")

                switch itemKind {
                case .object(let fields):
                    objectFields(
                        fields,
                        path: "",
                        value: value,
                        controlPrefix: "template-list-\(index)",
                        isPrototype: isPrototype,
                        context: &context
                    )
                default:
                    fieldControl(
                        key: "$value",
                        title: singularTitle,
                        kind: itemKind,
                        editor: editor,
                        value: value,
                        controlPrefix: "template-list-\(index)",
                        context: &context,
                        required: itemKind != .boolean
                    )
                }
            }
            .class("template-list-editor__item")
            .data("template-list-item", "true")
            .if(isPrototype) {
                $0.class("template-list-editor__prototype")
                    .data("template-list-prototype", "true")
            }
        }

        private func objectFields(
            _ fields: [WebModule.Template.Field],
            path: String,
            value: WebModule.Template.Value,
            controlPrefix: String,
            isPrototype: Bool,
            context: inout BuilderContext
        ) -> Div {
            Div {
                for field in fields {
                    let fieldPath = path.isEmpty
                        ? field.key
                        : "\(path).\(field.key)"
                    let fieldLabel = field.title
                    let fieldValue = objectValue(
                        field.key,
                        in: value
                    ) ?? emptyValue(for: field.kind)
                    switch field.kind {
                    case .object(let children):
                        objectFields(
                            children,
                            path: fieldPath,
                            value: fieldValue,
                            controlPrefix: controlPrefix,
                            isPrototype: isPrototype,
                            context: &context
                        )
                    case .list:
                        fieldControl(
                            key: fieldPath,
                            title: fieldLabel,
                            kind: field.kind,
                            editor: field.editor,
                            value: fieldValue,
                            controlPrefix: controlPrefix,
                            context: &context,
                            required: field.required,
                            isDisabled: isPrototype
                        )
                    default:
                        fieldControl(
                            key: fieldPath,
                            title: fieldLabel,
                            kind: field.kind,
                            editor: field.editor,
                            value: fieldValue,
                            controlPrefix: controlPrefix,
                            context: &context,
                            required: field.required,
                            isDisabled: isPrototype
                        )
                    }
                }
            }
            .class("template-list-editor__fields")
        }

        private func fieldControl(
            key: String,
            title: String,
            kind: WebModule.Template.Field.Kind,
            editor: WebModule.Template.Field.Editor = .input,
            value: WebModule.Template.Value,
            controlPrefix: String,
            context: inout BuilderContext,
            required: Bool = false,
            isDisabled: Bool = false
        ) -> Div {
            let controlName = "template-list-editor-control-\(controlPrefix)-\(key)"
            return Div {
                if kind == .string && editor == .textarea {
                    context.build(
                        AdminFormFieldTextArea(
                            state: .init(
                                name: controlName,
                                label: title,
                                value: stringValue(value),
                                style: .small,
                                isRequired: required,
                                isDisabled: isDisabled
                            )
                        )
                    )
                }
                else {
                    switch kind {
                case .boolean:
                    context.build(
                        AdminFormFieldCheckbox(
                            state: .init(
                                name: controlName,
                                checkboxLabel: title,
                                isChecked: boolValue(value),
                                isDisabled: isDisabled
                            )
                        )
                    )
                case .object:
                    context.build(
                        AdminFormFieldInput(
                            state: .init(
                                name: controlName,
                                label: title,
                                value: "",
                                isDisabled: isDisabled
                            )
                        )
                    )
                case .list:
                    context.build(
                        AdminFormFieldTextArea(
                            state: .init(
                                name: controlName,
                                label: title,
                                value: encodedValue(value),
                                style: .small,
                                isRequired: required,
                                isDisabled: isDisabled
                            )
                        )
                    )
                default:
                    context.build(
                        AdminFormFieldInput(
                            state: .init(
                                name: controlName,
                                label: title,
                                value: stringValue(value),
                                type: kind == .integer
                                    ? .number
                                    : kind == .date ? .date : .text,
                                isRequired: required,
                                isDisabled: isDisabled
                            )
                        )
                    )
                    }
                }
            }
            .data("template-list-path", key)
            .data("template-list-kind", kindName(kind))
        }

        private var encodedValues: String {
            guard
                let data = try? JSONEncoder().encode(
                    WebModule.Template.Value.array(values)
                ),
                let string = String(data: data, encoding: .utf8)
            else {
                return "[]"
            }
            return string
        }

        private var singularTitle: String {
            if title.hasSuffix("boxes") {
                return String(title.dropLast(2))
            }
            return title.hasSuffix("s") ? String(title.dropLast()) : title
        }

        private func objectValue(
            _ key: String,
            in value: WebModule.Template.Value
        ) -> WebModule.Template.Value? {
            guard case .object(let object) = value else { return nil }
            return object[key]
        }

        private func emptyValue(
            for kind: WebModule.Template.Field.Kind
        ) -> WebModule.Template.Value {
            switch kind {
            case .object(let fields):
                var values: [String: WebModule.Template.Value] = [:]
                for field in fields {
                    values[field.key] = field.defaultValue
                        ?? emptyValue(for: field.kind)
                }
                return .object(values)
            case .list: return .array([])
            case .boolean: return .boolean(false)
            case .integer: return .integer(0)
            case .float, .double: return .number(0)
            case .string, .date: return .string("")
            }
        }

        private func boolValue(
            _ value: WebModule.Template.Value
        ) -> Bool {
            guard case .boolean(let value) = value else { return false }
            return value
        }

        private func stringValue(
            _ value: WebModule.Template.Value
        ) -> String {
            switch value {
            case .string(let value): value
            case .integer(let value): String(value)
            case .number(let value): String(value)
            case .boolean(let value): value ? "true" : "false"
            case .object, .array, .null: ""
            }
        }

        private func encodedValue(
            _ value: WebModule.Template.Value
        ) -> String {
            guard
                let data = try? JSONEncoder().encode(value),
                let string = String(data: data, encoding: .utf8)
            else {
                return "[]"
            }
            return string
        }

        private func kindName(
            _ kind: WebModule.Template.Field.Kind
        ) -> String {
            switch kind {
            case .string: "string"
            case .boolean: "boolean"
            case .integer: "integer"
            case .float: "float"
            case .double: "double"
            case .date: "date"
            case .object: "object"
            case .list: "list"
            }
        }

    }
}
