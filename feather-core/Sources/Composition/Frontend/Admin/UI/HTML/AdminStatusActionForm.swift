import HTML
import SGML
import WebComponents
import WebBuilders

private typealias HTMLButton = HTML.Button

public struct AdminStatusActionForm: Leaf {
    let action: String
    let returnTo: String
    let status: String
    let label: String
    let classes: [String]

    public init(
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

    public func renderHTML() -> Form {
        Form {
            Input()
                .type(.hidden)
                .name("returnTo")
                .value(returnTo)
            Input()
                .type(.hidden)
                .name("status")
                .value(status)
            HTMLButton(label)
                .type(.submit)
                .class(classes.joined(separator: " "))
        }
        .method(.post)
        .action(action)
        .style("display:inline")
    }

}
