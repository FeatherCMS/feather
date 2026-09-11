import HTML
import SGML
import WebBuilders
import WebComponents

public struct AdminStatusSelectFormDefinition: Component {
    public let id: String
    public let action: String
    public let returnTo: String

    public init(id: String, action: String, returnTo: String) {
        self.id = id
        self.action = action
        self.returnTo = returnTo
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
        .style("display:none;")
    }

}
