import HTML
import SGML
import WebComponents
import WebBuilders

private typealias HTMLButton = HTML.Button

public struct ListTableSearchForm: Leaf {

    public struct State: Sendable {
        public let action: String
        public let placeholder: String
        public let search: String
        public let resetPath: String
        public let queryItems: [(String, String)]

        public init(
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

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func html() -> Form {
        Form {
            for item in state.queryItems {
                Input().type(.hidden).name(item.0).value(item.1)
            }
            Input()
                .type(.search)
                .name("search")
                .value(state.search)
                .placeholder(state.placeholder)
            HTMLButton("Search").type(.submit)
            A("Reset")
                .href(state.resetPath)
                .class("table-search-reset")
        }
        .method(.get)
        .action(state.action)
        .class("table-search-form")
    }
}
