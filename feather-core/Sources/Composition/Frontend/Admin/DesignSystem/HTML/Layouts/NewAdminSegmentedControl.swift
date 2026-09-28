public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminSegmentedControl: Component {
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

    public func rules() -> [any Rule] {
        Media {
            Class("new-admin-segmented-control") {
                Display(.inlineFlex)
                AlignItems(.center)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                BorderRadius(10.px)
                Padding(3.px)
                MaxWidth(100.percent)
            }
            Custom(".new-admin-segmented-control__track") {
                Display(.flex)
                AlignItems(.center)
                Gap(2.px)
                MaxWidth(100.percent)
            }
            Custom(".new-admin-segmented-control__track a") {
                Border(0)
                BorderRadius(7.px)
                BackgroundColor(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                Padding(vertical: 5.px, horizontal: 10.px)
                FontSize(0.84.rem)
                LineHeight(1.2)
                TextAlign(.center)
                Cursor(.pointer)
                TextDecoration(.none)
                WhiteSpace(.nowrap)
            }
            Custom(
                ".new-admin-segmented-control__track a:hover:not(.is-current)"
            ) {
                Color(.variable(TokenKey.Colors.Link.hover))
                TextDecoration(.underline)
            }
            Custom(".new-admin-segmented-control__track a.is-current") {
                Background(.variable(TokenKey.Colors.Accents.Primary.tint))
                Color(.variable(TokenKey.Colors.Accents.Primary.text))
            }
        }
    }

    public func html(context _: inout BuilderContext) -> Div {
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
            .class("new-admin-segmented-control__track")
        }
        .class("new-admin-segmented-control")
    }
}
