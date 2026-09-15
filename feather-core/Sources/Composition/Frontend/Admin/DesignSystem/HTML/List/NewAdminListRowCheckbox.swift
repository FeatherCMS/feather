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

    public func html(context: inout BuilderContext) -> Td {
        Td {
            context.build(
                NewAdminCheckbox(
                    name: "ids",
                    value: id,
                    ariaLabel: "Select row",
                    classes: ["select-row"]
                )
            )
        }
        .data("label", "Select")
        .class("select-cell")
    }
}
