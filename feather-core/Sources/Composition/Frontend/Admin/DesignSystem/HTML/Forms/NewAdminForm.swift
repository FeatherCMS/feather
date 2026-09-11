import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminForm: Component {
    public struct HiddenField: Sendable {
        public let name: String
        public let value: String

        public init(name: String, value: String) {
            self.name = name
            self.value = value
        }
    }

    private let form: Form

    public init(
        action: String,
        method: MethodAttributeValue = .post,
        nonceToken: String? = nil,
        hiddenFields: [HiddenField] = [],
        @Builder<FlowContent> content: () -> [any FlowContent]
    ) {
        self.form = Form {
            if let nonceToken {
                Input().type(.hidden).name("_nonce").value(nonceToken)
            }
            for field in hiddenFields {
                Input().type(.hidden).name(field.name).value(field.value)
            }
            content()
        }
        .encType(.urlencoded)
        .method(method)
        .action(action)
        .class("new-admin-form")
    }

    public func selectors() -> [any Selector] {
        [
            Class("new-admin-form") {
                Display(.flex)
                FlexDirection(.column)
                Gap(16.px)
                MaxWidth(640.px)
            },
            Custom(".new-admin-form > .new-admin-form__messages") {
                Display(.flex)
                FlexDirection(.column)
                Gap(6.px)
            },
            Custom(".new-admin-form > .new-admin-form__error") {
                Margin(0)
                Padding(10.px)
                BorderRadius(8.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
            },
            Class("new-admin-form__actions") {
                Display(.flex)
                AlignItems(.center)
                Gap(10.px)
                FlexWrap(.wrap)
                MarginTop(4.px)
            },
        ]
    }

    public func html(context: inout RenderContext) -> Form {
        form
    }
}
