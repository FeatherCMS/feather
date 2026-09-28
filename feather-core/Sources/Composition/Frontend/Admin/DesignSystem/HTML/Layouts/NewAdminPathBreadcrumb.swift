public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminPathBreadcrumb: Component {
    public struct Item: Sendable {
        public let label: String
        public let href: String?
        public let isCurrent: Bool

        public init(
            label: String,
            href: String? = nil,
            isCurrent: Bool = false
        ) {
            self.label = label
            self.href = href
            self.isCurrent = isCurrent
        }
    }

    public let items: [Item]

    public init(items: [Item]) {
        self.items = items
    }

    public func rules() -> [any Rule] {
        Media {
            Class("new-admin-path-breadcrumb") {
                Display(.flex)
                AlignItems(.center)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Secondary.border)
                )
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                BorderRadius(10.px)
                Padding(3.px)
                MinWidth(0.px)
                MarginBottom(12.px)
            }
            Custom(".new-admin-path-breadcrumb ol") {
                ListStyle(.none)
                Margin(0)
                Padding(0)
                Display(.flex)
                FlexWrap(.wrap)
                AlignItems(.center)
                Gap(2.px)
                MinWidth(0.px)
            }
            Custom(".new-admin-path-breadcrumb li") {
                Display(.inlineFlex)
                AlignItems(.center)
                MinWidth(0.px)
                FontSize(0.9.rem)
                LineHeight(1.2)
            }
            Custom(".new-admin-path-breadcrumb li:not(:last-child)::after") {
                Content(.string("\"›\""))
                MarginLeft(2.px)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            }
            Custom(
                ".new-admin-path-breadcrumb a, .new-admin-path-breadcrumb span"
            ) {
                Display(.inlineFlex)
                AlignItems(.center)
                WhiteSpace(.normal)
                UnsafeRawProperty(name: "overflow-wrap", value: "anywhere")
                Padding(vertical: 6.px, horizontal: 10.px)
            }
            Custom(".new-admin-path-breadcrumb a") {
                Color(.variable(TokenKey.Colors.Link.default))
                TextDecoration(.none)
            }
            Custom(".new-admin-path-breadcrumb a:hover") {
                Color(.variable(TokenKey.Colors.Link.hover))
                TextDecoration(.underline)
            }
            Custom(".new-admin-path-breadcrumb .is-current") {
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                FontWeight(.number(600))
            }
        }
    }

    public func html(context _: inout BuilderContext) -> Nav {
        Nav {
            Ol {
                for item in items {
                    Li {
                        if item.isCurrent || item.href == nil {
                            Span(item.label)
                                .class("is-current")
                                .title(item.label)
                        }
                        else if let href = item.href {
                            A(item.label)
                                .href(href)
                                .title(item.label)
                        }
                    }
                }
            }
        }
        .class("new-admin-path-breadcrumb")
        .ariaLabel("Folder path")
    }
}
