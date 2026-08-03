import HTML
import SGML
import WebStandards

struct ListTableRowActions: Component {

    struct Action {
        let title: String
        let href: String
        let className: String?
        let permission: String
        let copyText: String?

        init(
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

    struct State {
        let label: String
        let actions: [Action]
        let permissions: Set<String>
    }

    let state: State

    func content() -> some BasicTag {
        Td {
            let visibleActions = state.actions.filter {
                state.permissions.contains($0.permission)
            }

            for (index, action) in visibleActions.enumerated() {
                if let copyText = action.copyText {
                    Button(action.title)
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
