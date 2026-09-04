import HTML
import SGML
import WebComponents
import WebBuilders

private typealias HTMLButton = HTML.Button

public struct ListTableRowActions: Leaf {

    public struct Action: Sendable {
        public let title: String
        public let href: String
        public let className: String?
        public let permission: String
        public let copyText: String?

        public init(
            title: String,
            href: String = "#",
            className: String? = nil,
            permission: String,
            copyText: String? = nil
        ) {
            self.title = title
            self.href = href
            self.className = className
            self.permission = permission
            self.copyText = copyText
        }
    }

    public struct State: Sendable {
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
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func renderHTML() -> some BasicTag {
        Td {
            let visibleActions = state.actions.filter {
                state.permissions.contains($0.permission)
            }

            for (index, action) in visibleActions.enumerated() {
                if let copyText = action.copyText {
                    HTMLButton(action.title)
                        .type(.button)
                        .class("row-btn", action.className ?? "")
                        .onClick(
                            "navigator.clipboard.writeText('\(copyText)').then(()=>window.toast&&window.toast.show({type:'success',title:'Copied',message:'Contact form embed code copied to the clipboard.',position:'top-right'}))"
                        )
                }
                else if let className = action.className {
                    A(action.title)
                        .href(action.href)
                        .class("row-btn", className)
                }
                else {
                    A(action.title)
                        .href(action.href)
                        .class("row-btn")
                }

                if index < visibleActions.count - 1 {
                    Span(" ")
                }
            }
        }
        .data("label", state.label)
        .class("action-cell")
    }
}
