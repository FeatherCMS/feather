import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminFormFieldCheckbox: Component {
    public struct State: Sendable {
        public let name: String
        public let label: String
        public let isChecked: Bool
        public let error: String?
        public let help: String?
        public let isDisabled: Bool

        public init(
            name: String,
            label: String,
            isChecked: Bool = false,
            error: String? = nil,
            help: String? = nil,
            isDisabled: Bool = false
        ) {
            self.name = name
            self.label = label
            self.isChecked = isChecked
            self.error = error
            self.help = help
            self.isDisabled = isDisabled
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func selectors() -> [any Selector] {
        [
            Class("new-admin-form-checkbox") {
                Display(.flex)
                FlexDirection(.column)
                Gap(6.px)
            },
            Class("new-admin-form-checkbox__label") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Cursor(.pointer)
            },
            Custom(".new-admin-form-checkbox input") {
                Width(18.px)
                Height(18.px)
                Margin(0.px)
                FlexShrink(0)
                UnsafeRawProperty(name: "appearance", value: "none")
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(4.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Cursor(.pointer)
            },
            Custom(".new-admin-form-checkbox input:checked") {
                Background(.variable(TokenKey.Colors.Link.default))
                BorderColor(.variable(TokenKey.Colors.Link.default))
            },
            Custom(".new-admin-form-checkbox input:focus-visible") {
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(2.px)
            },
            Custom(".new-admin-form-checkbox input:checked::after") {
                Content(.string("\"✓\""))
                Display(.block)
                Color(.white)
                FontSize(13.px)
                LineHeight(16.px)
                TextAlign(.center)
            },
            Custom(".new-admin-form-checkbox .field-help") {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.86.rem)
            },
            Custom(".new-admin-form-checkbox .field-error") {
                Color(.red)
                FontSize(0.86.rem)
            },
        ]
    }

    public func html(context: inout RenderContext) -> Section {
        let errorID = "\(state.name)-error"
        return Section {
            Label {
                Input()
                    .type(.checkbox)
                    .name(state.name)
                    .id(state.name)
                    .value("true")
                    .ariaInvalid(state.error == nil ? .false : .true)
                    .if(state.error != nil) { $0.ariaErrorMessage(errorID) }
                    .if(state.isChecked) { $0.checked() }
                    .if(state.isDisabled) { $0.disabled() }
                Span(state.label)
            }
            .class("new-admin-form-checkbox__label")
            .for(state.name)
            if let help = state.help { Span(help).class("field-help") }
            if let error = state.error {
                Span(error).id(errorID).class("field-error")
            }
        }
        .if(state.error != nil) { $0.class("has-error") }
        .class("new-admin-form-checkbox")
    }
}
