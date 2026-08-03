import HTML
import SGML
import WebStandards

struct ListTableSelectAllCheckbox: Component {

    func content() -> some BasicTag {
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
