public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminCheckbox: Component {
    public let name: String?
    public let value: String?
    public let id: String?
    public let ariaLabel: String?
    public let isChecked: Bool
    public let isDisabled: Bool
    public let isInvalid: Bool?
    public let errorID: String?
    public let onChange: String?
    public let classes: [String]

    public init(
        name: String? = nil,
        value: String? = nil,
        id: String? = nil,
        ariaLabel: String? = nil,
        isChecked: Bool = false,
        isDisabled: Bool = false,
        isInvalid: Bool? = nil,
        errorID: String? = nil,
        onChange: String? = nil,
        classes: [String] = []
    ) {
        self.name = name
        self.value = value
        self.id = id
        self.ariaLabel = ariaLabel
        self.isChecked = isChecked
        self.isDisabled = isDisabled
        self.isInvalid = isInvalid
        self.errorID = errorID
        self.onChange = onChange
        self.classes = classes
    }

    public func selectors() -> [any Selector] {
        [
            Class("new-admin-checkbox") {
                Width(18.px)
                Height(18.px)
                Margin(0.px)
                FlexShrink(0)
                UnsafeRawProperty(name: "appearance", value: "none")
                Position(.relative)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(4.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Cursor(.pointer)
            },
            Custom(".new-admin-checkbox:checked") {
                Background(.variable(TokenKey.Colors.Link.default))
                BorderColor(.variable(TokenKey.Colors.Link.default))
            },
            Custom(".new-admin-checkbox:focus-visible") {
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(2.px)
            },
            Custom(".new-admin-checkbox:checked::after") {
                Content(.string("\"\""))
                Display(.block)
                Position(.absolute)
                Top(50.percent)
                Left(50.percent)
                Transform(.translate((-50).percent, (-50).percent))
                Width(8.px)
                Height(8.px)
                BorderRadius(999.px)
                Background(.white)
            },
        ]
    }

    public func html(context: inout BuilderContext) -> Input {
        var input = Input()
            .type(.checkbox)
            .class(
                ([
                    "new-admin-checkbox"
                ] + classes)
                .joined(separator: " ")
            )
        if let name { input = input.name(name) }
        if let value { input = input.value(value) }
        if let id { input = input.id(id) }
        if let ariaLabel { input = input.ariaLabel(ariaLabel) }
        if let isInvalid {
            input = input.ariaInvalid(isInvalid ? .true : .false)
        }
        if let errorID { input = input.ariaErrorMessage(errorID) }
        if isChecked { input = input.checked() }
        if isDisabled { input = input.disabled() }
        if let onChange { input = input.onChange(onChange) }
        return input
    }
}
