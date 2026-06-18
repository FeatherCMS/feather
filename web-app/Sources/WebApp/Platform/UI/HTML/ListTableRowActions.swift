import HTML
import SGML
import WebStandards

struct ListTableRowActions: Component {

    struct Action {
        let title: String
        let href: String
        let className: String?
        let permission: String
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
                if let className = action.className {
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
        .setAttribute(name: "data-label", value: state.label)
        .class("action-cell")
    }
}
