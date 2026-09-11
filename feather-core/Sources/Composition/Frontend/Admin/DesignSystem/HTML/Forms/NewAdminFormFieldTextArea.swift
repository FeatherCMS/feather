import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminFormFieldTextArea: Component {
    public enum Style: Sendable {
        case small
        case medium
        case large

        var rows: Int {
            switch self {
            case .small: return 3
            case .medium: return 6
            case .large: return 9
            }
        }

        var className: String {
            switch self {
            case .small: return "small"
            case .medium: return "medium"
            case .large: return "large"
            }
        }
    }

    public struct State: Sendable {
        public var name: String
        public var label: String
        public var value: String?
        public var error: String?
        public var help: String?
        public var style: Style
        public var isRequired: Bool
        public var isDisabled: Bool
        public var isReadOnly: Bool

        public init(
            name: String,
            label: String,
            value: String? = nil,
            error: String? = nil,
            help: String? = nil,
            style: Style = .medium,
            isRequired: Bool = false,
            isDisabled: Bool = false,
            isReadOnly: Bool = false
        ) {
            self.name = name
            self.label = label
            self.value = value
            self.error = error
            self.help = help
            self.style = style
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
            Custom(".new-admin-form-textarea") {
                Display(.flex)
                FlexDirection(.column)
                Gap(6.px)
            },
            Custom(".new-admin-form-textarea label") {
                FontWeight(.number(600))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom(".new-admin-form-textarea textarea") {
                Width(100.percent)
                BoxSizing(.borderBox)
                Padding(vertical: 9.px, horizontal: 11.px)
                Border(1.px, .solid, .variable(TokenKey.Colors.Materials.Primary.border))
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                Resize(.none)
            },
            Custom(".new-admin-form-textarea--small textarea") {
                UnsafeRawProperty(name: "min-height", value: "3lh")
            },
            Custom(".new-admin-form-textarea--medium textarea") {
                UnsafeRawProperty(name: "min-height", value: "6lh")
            },
            Custom(".new-admin-form-textarea--large textarea") {
                UnsafeRawProperty(name: "min-height", value: "9lh")
            },
            Custom(".new-admin-form-textarea textarea:focus") {
                BorderColor(.variable(TokenKey.Colors.Materials.Tertiary.hover))
                Outline(0.px, .none)
            },
            Custom(".new-admin-form-textarea .field-error") {
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                FontSize(0.86.rem)
            },
            Custom(".new-admin-form-textarea.has-error textarea") {
                BorderColor(.variable(TokenKey.Colors.Materials.Secondary.border))
            },
        ]
    }

    public func html(context: inout RenderContext) -> Section {
        Section {
            Label {
                Span(state.label)
                Textarea(state.value ?? "")
                    .name(state.name)
                    .id(state.name)
                    .rows(state.style.rows)
                    .ariaInvalid(state.error == nil ? .false : .true)
                    .if(state.isRequired) { $0.required() }
                    .if(state.isDisabled) { $0.disabled() }
                    .if(state.isReadOnly) { $0.readOnly() }
            }
            .for(state.name)
            if let help = state.help { Span(help).class("field-help") }
            if let error = state.error { Span(error).class("field-error") }
        }
        .if(state.error != nil) { $0.class("has-error") }
        .class("new-admin-form-textarea new-admin-form-textarea--(state.style.className)")
    }
}
