import HTML
import SGML
import WebStandards

public struct AdminStatusSelectFormDefinition: Component, FlowContent {
    public let id: String
    public let action: String
    public let returnTo: String

    public init(id: String, action: String, returnTo: String) {
        self.id = id
        self.action = action
        self.returnTo = returnTo
    }

    public func content() -> some BasicTag {
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
