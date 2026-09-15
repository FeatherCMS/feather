import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminPillTab: Component {
    public struct Link: Sendable {
        public let label: String
        public let href: String
        public let isCurrent: Bool

        public init(
            label: String,
            href: String,
            isCurrent: Bool
        ) {
            self.label = label
            self.href = href
            self.isCurrent = isCurrent
        }
    }

    public let links: [Link]

    public init(
        links: [Link]
    ) {
        self.links = links
    }

    public func rules() -> [any Rule] {
        Media {
            Class("pill-tabs") {
                Display(.block)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Secondary.border)
                )
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                BoxSizing(.borderBox)
                BorderRadius(999.px)
                MarginBottom(16.px)
                Padding(4.px)
                Width(100.percent)
                MaxWidth(100.percent)
                MinWidth(0.px)
                UnsafeRawProperty(
                    name: "contain",
                    value: "inline-size"
                )
                OverflowX(.hidden)
                OverflowY(.hidden)
            }
            Custom(".pill-tabs__scroll") {
                Display(.block)
                Width(100.percent)
                MaxWidth(100.percent)
                MinWidth(0.px)
                OverflowX(.auto)
                OverflowY(.hidden)
                UnsafeRawProperty(
                    name: "overscroll-behavior-x",
                    value: "contain"
                )
                UnsafeRawProperty(
                    name: "scrollbar-width",
                    value: "none"
                )
                UnsafeRawProperty(
                    name: "-ms-overflow-style",
                    value: "none"
                )
                UnsafeRawProperty(
                    name: "-webkit-overflow-scrolling",
                    value: "touch"
                )
            }
            Custom(".pill-tabs__track") {
                Display(.flex)
                FlexWrap(.nowrap)
                Gap(4.px)
                Width(100.percent)
                MaxWidth(100.percent)
                MinWidth(0.px)
            }
            Custom(".pill-tabs__scroll::-webkit-scrollbar") {
                Display(.none)
            }
            Custom(".pill-tabs__track a") {
                Flex(0, .number(0), .auto)
                UnsafeRawProperty(
                    name: "width",
                    value: "max-content"
                )
                Border(0)
                BorderRadius(999.px)
                BackgroundColor(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                Padding(vertical: 8.px, horizontal: 16.px)
                LineHeight(1.2)
                TextAlign(.center)
                Cursor(.pointer)
                TextDecoration(.none)
                WhiteSpace(.nowrap)
            }
            Custom(".pill-tabs__track a:hover:not(.is-current)") {
                Color(.variable(TokenKey.Colors.Link.hover))
                TextDecoration(.underline)
            }
            Custom(".pill-tabs__track a.is-current") {
                Background(.variable(TokenKey.Colors.Accents.Primary.tint))
                Color(.variable(TokenKey.Colors.Accents.Primary.text))
            }
        }
    }

    public func html(context _: inout RenderContext) -> Div {
        Div {
            Div {
                Div {
                    for link in links {
                        A(link.label)
                            .href(link.href)
                            .if(link.isCurrent) {
                                $0.class("is-current").ariaCurrent(.page)
                            }
                    }
                }
                .class("pill-tabs__track")
            }
            .class("pill-tabs__scroll")
        }
        .class("pill-tabs")
    }
}
