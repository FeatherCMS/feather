import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminFormFieldCheckbox: Component {
    public struct Input: Codable, Sendable, Equatable, Hashable {
        public let value: Bool

        public init(value: Bool) {
            self.value = value
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let boolValue = try? container.decode(Bool.self) {
                self.value = boolValue
                return
            }
            if let intValue = try? container.decode(Int.self) {
                self.value = intValue != 0
                return
            }
            let rawValue = try container.decode(String.self)
            let normalized = rawValue.lowercased()
            self.value =
                normalized == "on" || normalized == "true" || normalized == "1"
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.value ? "on" : "off")
        }
    }

    public struct State: Sendable {
        public let name: String
        public let label: String
        public let checkboxLabel: String
        public let isChecked: Bool
        public let error: String?
        public let help: String?
        public let isDisabled: Bool

        public init(
            name: String,
            label: String,
            checkboxLabel: String,
            isChecked: Bool = false,
            error: String? = nil,
            help: String? = nil,
            isDisabled: Bool = false
        ) {
            self.name = name
            self.label = label
            self.checkboxLabel = checkboxLabel
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
                Gap(8.px)
            },
            Class("new-admin-form-checkbox__label") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Cursor(.pointer)
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
            context.render(NewAdminFormFieldLabel(text: state.label))
            Label {
                context.render(
                    NewAdminCheckbox(
                        name: state.name,
                        value: "true",
                        id: state.name,
                        isChecked: state.isChecked,
                        isDisabled: state.isDisabled,
                        isInvalid: state.error != nil,
                        errorID: state.error == nil ? nil : errorID
                    )
                )
                Span(state.checkboxLabel)
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
