import CSS
import HTML
import SGML
import WebComponents
import WebBuilders

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

    public func rules(
    ) -> [any Rule] {
        Media {
            Class("pill-tabs") {
                Display(.flex)
                AlignItems(.center)
                Border(1.px, .solid, .variable(TokenKey.Colors.Materials.Secondary.border))
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                BoxSizing(.borderBox)
                BorderRadius(999.px)
                MarginBottom(16.px)
                Padding(4.px)
                Gap(4.px)
                Width(100.percent)
                OverflowX(.auto)
                OverflowY(.hidden)
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
            Custom(".pill-tabs::-webkit-scrollbar") {
                Display(.none)
            }
            Custom(".pill-tabs a") {
                Flex(1, .number(0), .auto)
                Border(0)
                BorderRadius(999.px)
                BackgroundColor(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                Padding(vertical: 8.px, horizontal: 12.px)
                LineHeight(1.2)
                TextAlign(.center)
                Cursor(.pointer)
                TextDecoration(.none)
                WhiteSpace(.nowrap)
            }
            Custom(".pill-tabs a:hover:not(.is-current)") {
                Color(.variable(TokenKey.Colors.Link.hover))
                TextDecoration(.underline)
            }
            Custom(".pill-tabs a.is-current") {
                Background(.variable(TokenKey.Colors.Accents.Primary.tint))
                Color(.variable(TokenKey.Colors.Accents.Primary.text))
            }
        }
    }

    public func html(context: inout RenderContext) -> Div {
        Div {
            for link in links {
                A(link.label)
                    .href(link.href)
                    .if(link.isCurrent) {
                        $0.class("is-current").ariaCurrent(.page)
                    }
            }
        }
        .class("pill-tabs")
    }
}
