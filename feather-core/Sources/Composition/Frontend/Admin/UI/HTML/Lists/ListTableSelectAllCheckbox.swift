import HTML
import SGML
import WebBuilders
import WebComponents

public struct ListTableSelectAllCheckbox: Component {

    public init() {}

    public func html(context: inout RenderContext) -> some BasicTag {
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
