import HTML
import SGML
import WebComponents
import WebBuilders

public struct NewAdminListRowCheckbox: Leaf {

    public let id: String

    public init(
        id: String
    ) {
        self.id = id
    }

    public func html(
    ) -> Td {
        Td {
            Input()
                .type(.checkbox)
                .name("selectedIds")
                .value(id)
                .ariaLabel("Select row")
                .class("select-row")
        }
        .data("label", "Select")
        .class("select-cell")
    }
}
