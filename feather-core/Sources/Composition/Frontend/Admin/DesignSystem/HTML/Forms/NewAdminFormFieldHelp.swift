import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminFormFieldHelp: Component {
    private let text: String
    private let id: String?

    public init(
        _ text: String,
        id: String? = nil
    ) {
        self.text = text
        self.id = id
    }

    public func selectors() -> [any CSS.Selector] {
        [
            Class("new-admin-form-field-help") {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.8.rem)
                LineHeight(1.35)
            },
        ]
    }

    public func html(context: inout BuilderContext) -> Span {
        if let id {
            return Span(text).id(id).class("new-admin-form-field-help")
        }
        return Span(text).class("new-admin-form-field-help")
    }
}
