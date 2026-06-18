import HTML
import SGML
import WebStandards

struct ListTableRowSelectCheckbox: Component {

    struct State {
        let id: String
    }

    let state: State

    func content() -> some BasicTag {
        Td {
            Input()
                .type(.checkbox)
                .name("selectedIds")
                .value(state.id)
                .ariaLabel("Select row")
                .class("bulk-select-row")
        }
        .setAttribute(name: "data-label", value: "Select")
        .class("bulk-select-cell")
    }
}
