import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

@available(*, deprecated, message: "Use the new admin design system instead.")
public struct AdminPillTabs: Component {
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

    public init(links: [Link]) {
        self.links = links
    }

    public func selectors() -> [any Selector] {
        Class("admin-pill-tabs") {
            Display(.block)
            //            Border(1.px, .solid, .variable(TokenKey.Background.primary))
            BorderRadius(999.px)
            MarginBottom(16.px)
            Padding(4.px)
            BoxSizing(.borderBox)
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
        Custom(".admin-pill-tabs__scroll") {
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
        Custom(".admin-pill-tabs__track") {
            Display(.flex)
            FlexWrap(.nowrap)
            Gap(4.px)
            Width(100.percent)
            MaxWidth(100.percent)
            MinWidth(0.px)
        }
        Custom(".admin-pill-tabs__scroll::-webkit-scrollbar") {
            Display(.none)
        }
        Custom(".admin-pill-tabs__track a") {
            Flex(0, .number(0), .auto)
            UnsafeRawProperty(
                name: "width",
                value: "max-content"
            )
            Border(0)
            BorderRadius(999.px)
            BackgroundColor(.transparent)
            //            Color(.variable(TokenKey.Background.primary))
            Padding(vertical: 8.px, horizontal: 16.px)
            LineHeight(1.2)
            TextAlign(.center)
            Cursor(.pointer)
            TextDecoration(.none)
            WhiteSpace(.nowrap)
        }
        Custom(".admin-pill-tabs a:hover:not(.is-current)") {
            //            Color(.variable(TokenKey.Background.primary))
            TextDecoration(.underline)
        }
        Custom(".admin-pill-tabs a.is-current") {
            //            Background(.variable(TokenKey.Background.primary))
            //            Color(.variable(TokenKey.Background.primary))
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
                                $0.class("is-current")
                            }
                    }
                }
                .class("admin-pill-tabs__track")
            }
            .class("admin-pill-tabs__scroll")
        }
        .class("admin-pill-tabs")
    }
}
