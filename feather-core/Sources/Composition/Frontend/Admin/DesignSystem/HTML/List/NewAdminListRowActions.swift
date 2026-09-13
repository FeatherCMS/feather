import CSS
import FeatherContracts
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminListRowActions: Component {

    public func rules() -> [any Rule] {
        Media {
            Class("action-cell") {
                Display(.flex)
                FlexWrap(.wrap)
                AlignItems(.center)
                JustifyContent(.flexStart)
                Gap(8.px)
                WhiteSpace(.normal)
                TextAlign(.left)
            }
            Custom(".action-cell .button ~ .button") {
                MarginLeft(0.px)
            }
        }
        Media(.maxWidth(768.px)) {
            Custom(".action-table td.action-cell") {
                Display(.block)
                WhiteSpace(.normal)
                TextAlign(.left)
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
        public let permission: PermissionKey
        public let copyText: String?

        public init(
            _ title: String,
            href: String? = nil,
            style: NewAdminButtonStyle = .secondary,
            permission: PermissionKey,
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
    public let permissions: NewAdminListActions

    public init(
        label: String,
        actions: [Action],
        permissions: NewAdminListActions
    ) {
        self.label = label
        self.actions = actions
        self.permissions = permissions
    }

    public func html(context: inout RenderContext) -> Td {
        let visibleActions = actions.filter {
            permissions.allows($0.permission)
        }

        return Td {
            for action in visibleActions {
                if let copyText = action.copyText {
                    context.render(
                        NewAdminControlButton(
                            action.title,
                            style: action.style
                        )
                    )
                    .onClick(
                        "navigator.clipboard.writeText('\(copyText)')"
                    )
                }
                else {
                    context.render(
                        NewAdminRowButton(
                            action.title,
                            href: action.href,
                            style: action.style
                        )
                    )
                }

            }
        }
        .data("label", label)
        .class("action-cell")
    }
}
