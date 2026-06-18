import HTML
import SGML
import WebStandards

struct AdminStatusSelectFormDefinition: Component, FlowContent {
    let id: String
    let action: String
    let returnTo: String

    func content() -> some BasicTag {
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
