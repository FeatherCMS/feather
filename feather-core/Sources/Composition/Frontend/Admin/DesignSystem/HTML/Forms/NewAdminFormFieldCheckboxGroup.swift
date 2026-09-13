import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminFormFieldCheckboxGroup: Component {
    public struct Option: Sendable {
        public let label: String
        public let value: String
        public let isSelected: Bool

        public init(label: String, value: String, isSelected: Bool = false) {
            self.label = label
            self.value = value
            self.isSelected = isSelected
        }
    }

    public let name: String
    public let label: String
    public let options: [Option]
    public let error: String?

    public init(
        name: String,
        label: String,
        options: [Option],
        error: String? = nil
    ) {
        self.name = name
        self.label = label
        self.options = options
        self.error = error
    }

    public func selectors() -> [any Selector] {
        [
            Custom(".new-admin-form-checkbox-group") {
                Display(.flex)
                FlexDirection(.column)
                Gap(6.px)
            },
            Custom(".new-admin-form-checkbox-group > .field-label") {
                FontWeight(.normal)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Opacity(0.8)
            },
            Custom(".new-admin-form-checkbox-group__options") {
                Display(.flex)
                FlexDirection(.column)
                Gap(8.px)
            },
            Custom(".new-admin-form-checkbox-group__option") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Cursor(.pointer)
                LineHeight(1.35)
            },
            Custom(".new-admin-form-checkbox-group.has-error input") {
                BorderColor(
                    .variable(TokenKey.Colors.Materials.Secondary.border)
                )
            },
            Custom(".new-admin-form-checkbox-group .field-error") {
                Color(.red)
                FontSize(0.86.rem)
            },
        ]
    }

    public func html(context: inout RenderContext) -> Section {
        let errorID = "\(name)-error"
        return Section {
            Span(label).class("field-label")
            Div {
                for option in options {
                    Label {
                        context.render(
                            NewAdminCheckbox(
                                name: name,
                                value: option.value,
                                ariaLabel: option.label,
                                isChecked: option.isSelected,
                                isInvalid: error != nil,
                                errorID: error == nil ? nil : errorID
                            )
                        )
                        Span(option.label)
                    }
                    .class("new-admin-form-checkbox-group__option")
                }
            }
            .class("new-admin-form-checkbox-group__options")
            if let error {
                Span(error).id(errorID).class("field-error")
            }
        }
        .if(error != nil) { $0.class("has-error") }
        .class("new-admin-form-checkbox-group")
    }
}
