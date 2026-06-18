import HTML
import SGML
import WebStandards

struct ListTableBulkRemoveForm<Table: FlowContent>: Component, FlowContent {

    struct State {
        let action: String
        let page: Int
        let search: String
        let canRemove: Bool
        let buttonTitle: String
        let queryItems: [(String, String)]

        init(
            action: String,
            page: Int,
            search: String,
            canRemove: Bool,
            buttonTitle: String,
            queryItems: [(String, String)] = []
        ) {
            self.action = action
            self.page = page
            self.search = search
            self.canRemove = canRemove
            self.buttonTitle = buttonTitle
            self.queryItems = queryItems
        }
    }

    let state: State
    let table: Table

    func content() -> some BasicTag {
        if state.canRemove {
            Form {
                table

                Div {
                    Button(state.buttonTitle)
                        .type(.submit)
                        .setAttribute(name: "disabled", value: "")
                        .class("bulk-remove-submit")
                        .class("row-btn", "delete")
                }
                .class("table-bulk-actions")

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

                for item in state.queryItems {
                    Input()
                        .type(.hidden)
                        .name(item.0)
                        .value(item.1)
                }

                Script(script())
            }
            .method(.get)
            .action(state.action)
            .class("table-bulk-remove-form")
        }
        else {
            table
        }
    }

    private func script() -> String {
        """
        (function () {
            function updateFormState(form) {
                var button = form.querySelector(".bulk-remove-submit");
                var rows = form.querySelectorAll("input.bulk-select-row");
                var selectAll = form.querySelector(".bulk-select-all");
                if (!button) { return; }
                var checkedCount = 0;
                rows.forEach(function (input) {
                    if (input.checked) {
                        checkedCount += 1;
                    }
                });
                button.disabled = checkedCount === 0;
                if (selectAll) {
                    selectAll.checked = rows.length > 0 && checkedCount === rows.length;
                    selectAll.indeterminate = checkedCount > 0 && checkedCount < rows.length;
                }
            }

            function initForm(form) {
                if (!form || form.dataset.bulkRemoveInitialized === "true") { return; }
                form.dataset.bulkRemoveInitialized = "true";
                form.querySelectorAll("input.bulk-select-row, input.bulk-select-all").forEach(function (input) {
                    input.addEventListener("change", function () {
                        updateFormState(form);
                    });
                });
                updateFormState(form);
            }

            function initAll() {
                document.querySelectorAll(".table-bulk-remove-form").forEach(initForm);
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
