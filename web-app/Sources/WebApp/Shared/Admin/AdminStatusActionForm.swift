import HTML
import SGML
import WebStandards

struct AdminStatusActionForm: Component, FlowContent {
    let action: String
    let returnTo: String
    let status: String
    let label: String
    let classes: [String]

    init(
        action: String,
        returnTo: String,
        status: String,
        label: String,
        classes: [String] = ["row-btn"]
    ) {
        self.action = action
        self.returnTo = returnTo
        self.status = status
        self.label = label
        self.classes = classes
    }

    func content() -> some BasicTag {
        Form {
            Input()
                .type(.hidden)
                .name("returnTo")
                .value(returnTo)
            Input()
                .type(.hidden)
                .name("status")
                .value(status)
            Button(label)
                .type(.submit)
                .class(classes.joined(separator: " "))
        }
        .method(.post)
        .action(action)
        .style("display:inline")
    }
}
