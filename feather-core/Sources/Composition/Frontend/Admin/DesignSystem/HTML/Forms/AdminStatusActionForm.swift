public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminStatusActionForm: Component {
    public let action: String
    public let returnTo: String
    public let status: String
    public let label: String
    public let classes: [String]

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

    public func selectors() -> [any CSS.Selector] {
        [
            Class("new-admin-status-action-form") {
                Display(.inline)
            }
        ]
    }

    public func html(context: inout BuilderContext) -> Form {
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
                .class(
                    ([
                        "button", "secondary",
                    ] + classes)
                    .joined(separator: " ")
                )
        }
        .method(.post)
        .action(action)
        .class("new-admin-status-action-form")
    }
}
