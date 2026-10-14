public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct AdminStatusSelectFormDefinition: Component {
    public let id: String
    public let action: String
    public let returnTo: String

    public init(id: String, action: String, returnTo: String) {
        self.id = id
        self.action = action
        self.returnTo = returnTo
    }

    public func selectors() -> [any CSS.Selector] {
        [
            Class("admin-status-select-form-definition") {
                Display(.none)
            }
        ]
    }

    public func html(context: inout BuilderContext) -> Form {
        Form {
            Input()
                .type(.hidden)
                .name("returnTo")
                .value(returnTo)
        }
        .id(id)
        .method(.post)
        .action(action)
        .class("admin-status-select-form-definition")
    }
}
