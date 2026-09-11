import HTML
import CSS
import SGML
import WebComponents
import WebBuilders

public struct NewAdminListSearch: Leaf {

    public func rules(
    ) -> [any Rule] {
        Media {
            Custom(".table-search-form") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
                FlexWrap(.wrap)
                MarginBottom(12.px)
            }
            Custom(".table-search-form input[type='search'], .table-search-form select") {
                Border(1.px, .solid, .variable(TokenKey.Colors.Materials.Primary.border))
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                Padding(vertical: 8.px, horizontal: 10.px)
                FontSize(0.9.rem)
            }
            Custom(".table-search-form select") {
                PaddingRight(34.px)
                UnsafeRawProperty(name: "appearance", value: "none")
            }
            Custom(".table-search-form input[type='search']") {
                Flex(1, .number(1), .auto)
                MinWidth(0.px)
                Width(100.percent)
            }
            Custom(".table-search-form :is(button, input[type='submit'])") {
                Flex(0, .number(0), .auto)
                Cursor(.pointer)
            }
            Custom(".table-search-form input[type='search']:focus, .table-search-form input[type='search']:focus-visible, .table-search-form select:focus, .table-search-form select:focus-visible") {
                BorderColor(.variable(TokenKey.Colors.Materials.Primary.border))
                BoxShadow(0.px, 0.px, blur: 0.px, spread: 2.px, color: CSSColor(stringLiteral: "var(--\(TokenKey.Colors.Materials.Tertiary.hover.propertyName))"))
                Outline(0.px, .none)
            }
            Custom(".table-search-form .table-search-reset") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Padding(vertical: 8.px, horizontal: 12.px)
                FontSize(0.9.rem)
                FontWeight(.number(700))
            }
        }
        Media(.minWidth(769.px)) {
            Class("table-search-form") {
                Width(50.percent)
                MaxWidth(50.percent)
            }
        }
    }

    public struct QueryItem: Sendable {
        public let name: String
        public let value: String

        public init(
            name: String,
            value: String
        ) {
            self.name = name
            self.value = value
        }
    }

    public struct State: Sendable {
        public let action: String
        public let placeholder: String
        public let search: String
        public let resetPath: String
        public let queryItems: [QueryItem]

        public init(
            action: String,
            placeholder: String,
            search: String,
            resetPath: String? = nil,
            queryItems: [QueryItem] = []
        ) {
            self.action = action
            self.placeholder = placeholder
            self.search = search
            self.resetPath = resetPath ?? action
            self.queryItems = queryItems
        }
    }

    public let state: State
    public let additionalFields: [any FlowContent]

    public init(
        state: State,
        @Builder<FlowContent> additionalFields: () -> [any FlowContent] = { [] }
    ) {
        self.state = state
        self.additionalFields = additionalFields()
    }

    public func html(
    ) -> Form {
        Form {
            for item in state.queryItems {
                Input().type(.hidden).name(item.name).value(item.value)
            }
            Input()
                .type(.search)
                .name("search")
                .value(state.search)
                .placeholder(state.placeholder)
            for field in additionalFields {
                field
            }
            NewAdminSubmitButton("Search", style: .primary).html()
            A("Reset")
                .href(state.resetPath)
                .class("table-search-reset")
        }
        .method(.get)
        .action(state.action)
        .class("table-search-form")
    }
}
