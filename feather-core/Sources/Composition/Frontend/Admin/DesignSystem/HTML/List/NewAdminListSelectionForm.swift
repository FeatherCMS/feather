import HTML
import SGML
import WebComponents
import WebBuilders

public struct NewAdminListSelectionForm<Table: FlowContent>: Component {

    public struct State: Sendable {
        public let action: String
        public let page: Int
        public let search: String
        public let button: NewAdminSubmitButton
        public let isEnabled: Bool

        public init(
            action: String,
            page: Int,
            search: String,
            button: NewAdminSubmitButton,
            isEnabled: Bool = true
        ) {
            self.action = action
            self.page = page
            self.search = search
            self.button = button
            self.isEnabled = isEnabled
        }
    }

    public let state: State
    public let table: Table

    public init(state: State, table: Table) {
        self.state = state
        self.table = table
    }

    public func html(context: inout RenderContext) -> Div {
        Div {
            if state.isEnabled {
                Form {
                    table

                    Div {
                        context.render(state.button)
                            .disabled()
                            .class("remove-submit")
                    }
                    .class("table-actions")

                    Input()
                        .type(.hidden)
                        .name("page")
                        .value("\(state.page)")

                    if !state.search.isEmpty {
                        Input()
                            .type(.hidden)
                            .name("search")
                            .value(state.search)
                    }

                    Script(script())
                }
                .method(.get)
                .action(state.action)
                .class("table-remove-form")
            }
            else {
                table
            }
        }
    }

    private func script() -> String {
        """
        (function () {
            function updateFormState(form) {
                var button = form.querySelector(".remove-submit");
                var rows = form.querySelectorAll("input.select-row");
                var selectAll = form.querySelector(".select-all");
                if (!button) { return; }
                var checkedCount = 0;
                rows.forEach(function (input) {
                    if (input.checked) { checkedCount += 1; }
                });
                button.disabled = checkedCount === 0;
                if (selectAll) {
                    selectAll.checked = rows.length > 0 && checkedCount === rows.length;
                    selectAll.indeterminate = checkedCount > 0 && checkedCount < rows.length;
                }
            }

            function initForm(form) {
                if (!form || form.dataset.removeInitialized === "true") { return; }
                form.dataset.removeInitialized = "true";
                form.querySelectorAll("input.select-row, input.select-all").forEach(function (input) {
                    input.addEventListener("change", function () { updateFormState(form); });
                });
                updateFormState(form);
            }

            function initAll() {
                document.querySelectorAll(".table-remove-form").forEach(initForm);
            }

            if (document.readyState === "loading") {
                document.addEventListener("DOMContentLoaded", initAll, { once: true });
            } else {
                initAll();
            }
        })();
        """
    }
}
