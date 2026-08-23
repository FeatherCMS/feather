import HTML
import SGML
import WebStandards

public struct ListTableSelectAllCheckbox: Component {

    public init() {}

    public func content() -> some BasicTag {
        Th {
            Input()
                .type(.checkbox)
                .ariaLabel("Select all rows")
                .class("bulk-select-all")
                .onChange(
                    "this.closest('form').querySelectorAll('input.bulk-select-row').forEach(function(input) { input.checked = this.checked; }, this)"
                )
        }
        .class("bulk-select-cell")
    }
}
