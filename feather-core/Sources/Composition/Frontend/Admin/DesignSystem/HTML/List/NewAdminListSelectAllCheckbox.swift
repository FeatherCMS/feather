import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminListSelectAllCheckbox: Component {

    public init() {
    }

    public func html(context: inout BuilderContext) -> Th {
        Th {
            context.build(
                NewAdminCheckbox(
                    ariaLabel: "Select all rows",
                    onChange:
                        "this.closest('form').querySelectorAll('input.select-row').forEach(function(input) { input.checked = this.checked; }, this)",
                    classes: ["select-all"]
                )
            )
        }
        .class("select-cell")
    }
}
