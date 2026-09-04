import HTML
import SGML
import WebComponents
import WebBuilders

public struct ListTableSelectAllCheckbox: Leaf {

    public init() {}

    public func renderHTML() -> some BasicTag {
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
