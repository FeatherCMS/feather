import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminFormFieldSelect: Component {
    public struct SelectOption: Sendable {
        public let label: String
        public let value: String

        public init(label: String, value: String) {
            self.label = label
            self.value = value
        }
    }

    public struct State: Sendable {
        public var name: String
        public var label: String
        public var value: String?
        public var options: [SelectOption]
        public var error: String?
        public var isRequired: Bool
        public var isDisabled: Bool

        public init(
            name: String,
            label: String,
            value: String? = nil,
            options: [SelectOption],
            error: String? = nil,
            isRequired: Bool = false,
            isDisabled: Bool = false
        ) {
            self.name = name
            self.label = label
            self.value = value
            self.options = options
            self.error = error
            self.isRequired = isRequired
            self.isDisabled = isDisabled
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func selectors() -> [any Selector] {
        [
            Custom(".new-admin-form-field") {
                Display(.flex)
                FlexDirection(.column)
                Gap(6.px)
            },
            Custom(".new-admin-form-field label") {
                Display(.flex)
                FlexDirection(.column)
                Gap(8.px)
            },
            Custom(".new-admin-form-field select") {
                Width(100.percent)
                BoxSizing(.borderBox)
                Padding(vertical: 9.px, horizontal: 11.px)
                PaddingRight(30.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Cursor(.pointer)
                UnsafeRawProperty(name: "appearance", value: "none")
                UnsafeRawProperty(
                    name: "background-image",
                    value:
                        "linear-gradient(45deg, transparent 50%, currentColor 50%), linear-gradient(135deg, currentColor 50%, transparent 50%)"
                )
                UnsafeRawProperty(
                    name: "background-position",
                    value:
                        "calc(100% - 15px) 50%, calc(100% - 10px) 50%"
                )
                UnsafeRawProperty(name: "background-size", value: "5px 5px")
                UnsafeRawProperty(
                    name: "background-repeat",
                    value: "no-repeat"
                )
            },
            Custom(".new-admin-form-field select:focus-visible") {
                BorderColor(
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(2.px)
            },
            Custom(".new-admin-form-field .field-error") {
                Color(.red)
                FontSize(0.86.rem)
            },
            Custom(".new-admin-form-field.has-error select") {
                BorderColor(
                    .variable(TokenKey.Colors.Materials.Secondary.border)
                )
            },
        ]
    }

    public func html(context: inout RenderContext) -> Section {
        let errorID = "\(state.name)-error"
        return Section {
            Label {
                context.render(
                    NewAdminFormFieldLabel(
                        text: state.label,
                        isRequired: state.isRequired
                    )
                )
                Select {
                    for option in state.options {
                        Option(option.label)
                            .value(option.value)
                            .if(state.value == option.value) { $0.selected() }
                    }
                }
                .name(state.name)
                .id(state.name)
                .ariaInvalid(state.error == nil ? .false : .true)
                .if(state.error != nil) { $0.ariaErrorMessage(errorID) }
                .if(state.isRequired) { $0.required() }
                .if(state.isDisabled) { $0.disabled() }
            }
            .for(state.name)
            if let error = state.error {
                Span(error).id(errorID).class("field-error")
            }
        }
        .if(state.error != nil) { $0.class("has-error") }
        .class("new-admin-form-field")
    }
}
