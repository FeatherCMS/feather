import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminFormFieldInput: Component {
    public struct State: Sendable {
        public var name: String
        public var label: String
        public var value: String?
        public var error: String?
        public var help: String?
        public var type: Input.Types
        public var isRequired: Bool
        public var isDisabled: Bool
        public var isReadOnly: Bool

        public init(
            name: String,
            label: String,
            value: String? = nil,
            error: String? = nil,
            help: String? = nil,
            type: Input.Types = .text,
            isRequired: Bool = false,
            isDisabled: Bool = false,
            isReadOnly: Bool = false
        ) {
            self.name = name
            self.label = label
            self.value = value
            self.error = error
            self.help = help
            self.type = type
            self.isRequired = isRequired
            self.isDisabled = isDisabled
            self.isReadOnly = isReadOnly
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
                Gap(5.px)
                FontWeight(.normal)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Opacity(0.8)
            },
            Custom(".new-admin-form-field input") {
                Width(100.percent)
                BoxSizing(.borderBox)
                Padding(vertical: 9.px, horizontal: 11.px)
                Border(1.px, .solid, .variable(TokenKey.Colors.Materials.Secondary.border))
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
            },
            Custom(".new-admin-form-field input:focus") {
                BorderColor(.variable(TokenKey.Colors.Materials.Secondary.border))
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
            },
            Custom(".new-admin-form-field .field-error") {
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                FontSize(0.86.rem)
            },
            Custom(".new-admin-form-field.has-error input") {
                BorderColor(.variable(TokenKey.Colors.Materials.Secondary.border))
            },
        ]
    }

    public func html(context: inout RenderContext) -> Section {
        Section {
            Label {
                Span {
                    Span(state.label)
                    if !state.isRequired {
                        Span("(optional)").class("field-optional")
                    }
                }
                Input()
                    .type(state.type)
                    .name(state.name)
                    .id(state.name)
                    .ariaInvalid(state.error == nil ? .false : .true)
                    .if(state.value != nil) { $0.value(state.value) }
                    .if(state.isRequired) { $0.required() }
                    .if(state.isDisabled) { $0.disabled() }
                    .if(state.isReadOnly) { $0.readOnly() }
            }
            .for(state.name)
            if let help = state.help { Span(help).class("field-help") }
            if let error = state.error { Span(error).class("field-error") }
        }
        .if(state.error != nil) { $0.class("has-error") }
        .class("new-admin-form-field")
    }
}
