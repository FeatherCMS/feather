import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminStatusSelectFormDefinition: Component {
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
            Class("new-admin-status-select-form-definition") {
                Display(.none)
            }
        ]
    }

    public func html(context: inout RenderContext) -> Form {
        Form {
            Input()
                .type(.hidden)
                .name("returnTo")
                .value(returnTo)
        }
        .id(id)
        .method(.post)
        .action(action)
        .class("new-admin-status-select-form-definition")
    }
}
