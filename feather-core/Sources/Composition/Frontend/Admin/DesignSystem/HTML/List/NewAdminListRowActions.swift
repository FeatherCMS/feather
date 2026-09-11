import HTML
import CSS
import SGML
import WebComponents
import WebBuilders

public struct NewAdminListRowActions: Component {

    public func rules(
    ) -> [any Rule] {
        Media {
            Class("action-cell") {
                WhiteSpace(.nowrap)
                TextAlign(.right)
            }
        }
            Media(.maxWidth(768.px)) {
                Custom(".action-table td.action-cell") {
                    WhiteSpace(.nowrap)
                    TextAlign(.right)
                }
                Custom(".action-table td.action-cell::before") {
                    MarginBottom(8.px)
                }
            }

    }

    public struct Action: Sendable {
        public let title: String
        public let href: String?
        public let style: NewAdminButtonStyle
        public let permission: String
        public let copyText: String?

        public init(
            _ title: String,
            href: String? = nil,
            style: NewAdminButtonStyle = .secondary,
            permission: String,
            copyText: String? = nil
        ) {
            self.title = title
            self.href = href
            self.style = style
            self.permission = permission
            self.copyText = copyText
        }
    }

    public let label: String
    public let actions: [Action]
    public let permissions: Set<String>

    public init(
        label: String,
        actions: [Action],
        permissions: Set<String>
    ) {
        self.label = label
        self.actions = actions
        self.permissions = permissions
    }

    public func html(context: inout RenderContext) -> Td {
        let visibleActions = actions.filter {
            permissions.contains($0.permission)
        }

        return Td {
            for (index, action) in visibleActions.enumerated() {
                if let copyText = action.copyText {
                    context.render(NewAdminControlButton(
                        action.title,
                        style: action.style
                    ))
                    .onClick(
                        "navigator.clipboard.writeText('\(copyText)')"
                    )
                }
                else {
                    context.render(NewAdminRowButton(
                        action.title,
                        href: action.href,
                        style: action.style
                    ))
                }

                if index < visibleActions.count - 1 {
                    Span(" ")
                }
            }
        }
        .data("label", label)
        .class("action-cell")
    }
}
