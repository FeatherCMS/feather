import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminListSearch: Component {

    public func rules() -> [any Rule] {
        Media {
            Custom(".table-search-form") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
                FlexWrap(.nowrap)
                MarginBottom(0.px)
                Width(100.percent)
                MaxWidth(100.percent)
            }
            Custom(
                ".table-search-form input[type='search'], .table-search-form select"
            ) {
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Padding(vertical: 8.px, horizontal: 10.px)
                FontSize(0.9.rem)
            }
            Custom(".table-search-form select") {
                PaddingRight(34.px)
                UnsafeRawProperty(name: "appearance", value: "none")
            }
            Custom(".table-search-form input[type='search']") {
                MinWidth(0.px)
                Width(100.percent)
                PaddingRight(34.px)
            }
            Custom(
                ".table-search-form input[type='search']::-webkit-search-cancel-button"
            ) {
                Display(.none)
            }
            Custom(".table-search-form .table-search-input") {
                Position(.relative)
                Flex(1, .number(1), .auto)
                MinWidth(0.px)
                Width(100.percent)
            }
            Custom(".table-search-form :is(button, input[type='submit'])") {
                Flex(0, .number(0), .auto)
                Cursor(.pointer)
            }
            Custom(
                ".table-search-form input[type='search']:focus, .table-search-form input[type='search']:focus-visible, .table-search-form select:focus, .table-search-form select:focus-visible"
            ) {
                BorderColor(
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(2.px)
            }
            Custom(".table-search-form .table-search-reset") {
                Position(.absolute)
                Top(50.percent)
                Right(9.px)
                Transform(.translateY((-50).percent))
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Width(24.px)
                Height(24.px)
                Padding(0.px)
                BorderRadius(999.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(1.15.rem)
                LineHeight(1)
                TextDecoration(.none)
            }
            Custom(".table-search-form .table-search-reset.is-hidden") {
                Display(.none)
            }
            Custom(
                ".table-search-form .table-search-reset:hover, .table-search-form .table-search-reset:focus-visible"
            ) {
                Background(.variable(TokenKey.Colors.Materials.Tertiary.hover))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                Outline(0.px, .none)
            }
        }
        Media(.minWidth(769.px)) {
            Class("table-search-form") {
                Width(40.percent)
                MaxWidth(40.percent)
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

    public func html(context: inout RenderContext) -> Form {
        Form {
            for item in state.queryItems {
                Input().type(.hidden).name(item.name).value(item.value)
            }
            Div {
                Input()
                    .type(.search)
                    .name("search")
                    .value(state.search)
                    .placeholder(state.placeholder)
                A("×")
                    .href(state.resetPath)
                    .ariaLabel("Reset search")
                    .title("Reset search")
                    .class("table-search-reset")
                    .if(state.search.isEmpty) { $0.class("is-hidden") }
            }
            .class("table-search-input")
            for field in additionalFields {
                field
            }
            context.render(
                NewAdminSubmitButton(
                    "Search",
                    style: .ghost(.primary),
                    isRowButton: true
                )
            )
            Script(searchScript())
        }
        .method(.get)
        .action(state.action)
        .class("table-search-form")
    }

    private func searchScript() -> String {
        """
        document.addEventListener('DOMContentLoaded',function(){
            document.querySelectorAll('.table-search-form').forEach(function(form){
                var input=form.querySelector("input[name='search']");
                var reset=form.querySelector('.table-search-reset');
                if(!input||!reset){return;}
                var update=function(){reset.classList.toggle('is-hidden',input.value.length===0);};
                input.addEventListener('input',update);
                reset.addEventListener('click',function(){
                    input.value='';
                    update();
                });
                update();
            });
        });
        """
    }
}
