import HTML
import CSS
import SGML
import WebStandards

public struct AdminPillTabs: Component, FlowContent {

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
            Display(.flex)
            AlignItems(.center)
            Border(1.px, .solid, .variable("cms-gray-3"))
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
        Custom(".admin-pill-tabs::-webkit-scrollbar") {
            Display(.none)
        }
        Custom(".admin-pill-tabs a") {
            Flex(1, .number(0), .auto)
            Border(0)
            BorderRadius(999.px)
            BackgroundColor(.transparent)
            Color(.variable("cms-light-font"))
            Padding(vertical: 8.px, horizontal: 12.px)
            LineHeight(1.2)
            TextAlign(.center)
            Cursor(.pointer)
            TextDecoration(.none)
            WhiteSpace(.nowrap)
        }
        Custom(".admin-pill-tabs a:hover:not(.is-current)") {
            Color(.variable("cms-link-hover"))
            TextDecoration(.underline)
        }
        Custom(".admin-pill-tabs a.is-current") {
            BackgroundColor(.variable("cms-gray-4"))
            Color(.variable("cms-strong-font"))
        }
    }

    public func content() -> some BasicTag {
        Div {
            for link in links {
                A(link.label)
                    .href(link.href)
                    .if(link.isCurrent) {
                        $0.class("is-current")
                    }
            }
        }
        .class("admin-pill-tabs")
    }
}
