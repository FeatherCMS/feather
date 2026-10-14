public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct AdminFormFieldInput: Component {
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
            Custom(".admin-form-field") {
                Display(.flex)
                FlexDirection(.column)
                Gap(6.px)
            },
            Custom(".admin-form-field label") {
                Display(.flex)
                FlexDirection(.column)
                Gap(8.px)
            },
            Custom(".admin-form-field input") {
                Width(100.percent)
                BoxSizing(.borderBox)
                Padding(vertical: 9.px, horizontal: 11.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                FontSize(1.rem)
            },
            Custom(".admin-form-field input:focus") {
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
            Custom(".admin-form-field .field-error") {
                Color(.red)
                FontSize(0.86.rem)
            },
            Custom(".admin-form-field.has-error input") {
                BorderColor(
                    .variable(TokenKey.Colors.Materials.Secondary.border)
                )
            },
        ]
    }

    public func html(context: inout BuilderContext) -> Section {
        let errorID = "\(state.name)-error"
        return Section {
            Label {
                context.build(
                    AdminFormFieldLabel(
                        text: state.label,
                        isRequired: state.isRequired
                    )
                )
                Input()
                    .type(state.type)
                    .name(state.name)
                    .id(state.name)
                    .ariaInvalid(state.error == nil ? .false : .true)
                    .if(state.error != nil) { $0.ariaErrorMessage(errorID) }
                    .if(state.value != nil) { $0.value(state.value) }
                    .if(state.isRequired) { $0.required() }
                    .if(state.isDisabled) { $0.disabled() }
                    .if(state.isReadOnly) { $0.readOnly() }
            }
            .for(state.name)
            if let help = state.help {
                context.build(AdminFormFieldHelp(help))
            }
            if let error = state.error {
                Span(error).id(errorID).class("field-error")
            }
        }
        .if(state.error != nil) { $0.class("has-error") }
        .class("admin-form-field")
    }
}
