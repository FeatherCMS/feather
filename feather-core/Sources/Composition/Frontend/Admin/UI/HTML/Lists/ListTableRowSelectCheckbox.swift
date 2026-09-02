import HTML
import SGML
import WebStandards

public struct ListTableRowSelectCheckbox: Component {

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

    public func content() -> some BasicTag {
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
