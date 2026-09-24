public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminListSearch: Component {

    public func rules() -> [any Rule] {
        let root = ".table-search-form.new-admin-list-search"

        Media {
            Custom(root) {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
                FlexWrap(.nowrap)
                MarginBottom(0.px)
                Width(100.percent)
                MaxWidth(640.px)
            }
            Custom(
                "\(root) input[type='search'], \(root) select"
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
            Custom("\(root) select") {
                Width(190.px)
                Flex(0, .number(0), .auto)
                PaddingRight(34.px)
                UnsafeRawProperty(name: "appearance", value: "none")
                UnsafeRawProperty(
                    name: "background-image",
                    value:
                        "linear-gradient(45deg, transparent 50%, currentColor 50%), linear-gradient(135deg, currentColor 50%, transparent 50%)"
                )
                UnsafeRawProperty(
                    name: "background-position",
                    value:
                        "calc(100% - 19px) 50%, calc(100% - 14px) 50%"
                )
                UnsafeRawProperty(name: "background-size", value: "5px 5px")
                UnsafeRawProperty(
                    name: "background-repeat",
                    value: "no-repeat"
                )
            }
            Custom("\(root) input[type='search']") {
                MinWidth(0.px)
                Width(100.percent)
                PaddingRight(34.px)
            }
            Custom(
                "\(root) input[type='search']::-webkit-search-cancel-button"
            ) {
                Display(.none)
            }
            Custom("\(root) .table-search-input") {
                Position(.relative)
                Flex(1, .number(1), .auto)
                MinWidth(0.px)
                Width(100.percent)
            }
            Custom("\(root) :is(button, input[type='submit'])") {
                Flex(0, .number(0), .auto)
                Cursor(.pointer)
            }
            Custom(
                "\(root) input[type='search']:focus, \(root) input[type='search']:focus-visible, \(root) select:focus, \(root) select:focus-visible"
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
            Custom("\(root) .table-search-reset") {
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
            Custom("\(root) .table-search-reset.is-hidden") {
                Display(.none)
            }
            Custom(
                "\(root) .table-search-reset:hover, \(root) .table-search-reset:focus-visible"
            ) {
                Background(.variable(TokenKey.Colors.Materials.Tertiary.hover))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                Outline(0.px, .none)
            }
        }
        Media(.maxWidth(768.px)) {
            Custom(root) {
                FlexWrap(.wrap)
                Width(100.percent)
                MaxWidth(100.percent)
            }
            Custom("\(root) select") {
                Width(100.percent)
            }
            Custom("\(root) .table-search-input") {
                Width(100.percent)
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

    public func html(context: inout BuilderContext) -> Form {
        Form {
            for item in state.queryItems {
                Input().type(.hidden).name(item.name).value(item.value)
            }
            for field in additionalFields {
                field
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
            context.build(
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
        .class("table-search-form", "new-admin-list-search")
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
