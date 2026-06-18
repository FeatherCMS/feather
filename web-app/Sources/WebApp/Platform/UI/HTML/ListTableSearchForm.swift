import HTML
import SGML
import WebStandards

struct ListTableSearchForm: Component, FlowContent {

    struct State {
        let action: String
        let placeholder: String
        let search: String
        let resetPath: String
        let queryItems: [(String, String)]

        init(
            action: String,
            placeholder: String,
            search: String,
            resetPath: String? = nil,
            queryItems: [(String, String)] = []
        ) {
            self.action = action
            self.placeholder = placeholder
            self.search = search
            self.resetPath = resetPath ?? action
            self.queryItems = queryItems
        }
    }

    let state: State

    func content() -> some BasicTag {
        Form {
            for item in state.queryItems {
                Input().type(.hidden).name(item.0).value(item.1)
            }
            Input()
                .type(.search)
                .name("search")
                .value(state.search)
                .placeholder(state.placeholder)
            Button("Search").type(.submit)
            A("Reset")
                .href(state.resetPath)
                .class("table-search-reset")
        }
        .method(.get)
        .action(state.action)
        .class("table-search-form")
    }
}
