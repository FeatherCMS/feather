import HTML
import SGML
import WebComponents
import WebBuilders

public struct AdminStatusSelectFormDefinition: Leaf {
    public let id: String
    public let action: String
    public let returnTo: String

    public init(id: String, action: String, returnTo: String) {
        self.id = id
        self.action = action
        self.returnTo = returnTo
    }

    public func html() -> Form {
        Form {
            Input()
                .type(.hidden)
                .name("returnTo")
                .value(returnTo)
        }
        .id(id)
        .method(.post)
        .action(action)
        .style("display:none;")
    }

}
