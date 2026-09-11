import HTML
import SGML
import WebComponents
import WebBuilders

public struct NewAdminListSelectAllCheckbox: Component {

    public init(
    ) {
    }

    public func html(context: inout RenderContext) -> Th {
        Th {
            Input()
                .type(.checkbox)
                .ariaLabel("Select all rows")
                .class("select-all")
                .onChange(
                    "this.closest('form').querySelectorAll('input.select-row').forEach(function(input) { input.checked = this.checked; }, this)"
                )
        }
        .class("select-cell")
    }
}
