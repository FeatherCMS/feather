import HTML
import SGML
import WebComponents
import WebBuilders

public struct ListTableRowSelectCheckbox: Leaf {

    public struct State: Sendable {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func html() -> some BasicTag {
        Td {
            Input()
                .type(.checkbox)
                .name("selectedIds")
                .value(state.id)
                .ariaLabel("Select row")
                .class("select-row")
        }
        .data("label", "Select")
        .class("select-cell")
    }
}
