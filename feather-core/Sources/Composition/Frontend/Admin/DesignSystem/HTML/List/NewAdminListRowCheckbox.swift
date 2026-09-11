import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminListRowCheckbox: Component {

    public let id: String

    public init(
        id: String
    ) {
        self.id = id
    }

    public func html(context: inout RenderContext) -> Td {
        Td {
            Input()
                .type(.checkbox)
                .name("ids")
                .value(id)
                .ariaLabel("Select row")
                .class("select-row")
        }
        .data("label", "Select")
        .class("select-cell")
    }
}
