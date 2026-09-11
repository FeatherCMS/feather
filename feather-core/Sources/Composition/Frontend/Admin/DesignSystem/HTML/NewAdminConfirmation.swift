import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminConfirmation: Component {
    public struct HiddenField: Sendable {
        public let name: String
        public let value: String

        public init(name: String, value: String) {
            self.name = name
            self.value = value
        }
    }

    public let breadcrumb: NewAdminBreadcrumb.State
    public let title: String
    public let message: String
    public let details: [String]
    public let selectedIDs: [String]
    public let action: String
    public let cancel: String
    public let submitLabel: String
    public let cancelLabel: String
    public let hiddenFields: [HiddenField]

    public init(
        breadcrumb: NewAdminBreadcrumb.State,
        title: String,
        message: String,
        details: [String] = [],
        selectedIDs: [String] = [],
        action: String,
        cancel: String,
        submitLabel: String = "Remove",
        cancelLabel: String = "Cancel",
        hiddenFields: [HiddenField] = []
    ) {
        self.breadcrumb = breadcrumb
        self.title = title
        self.message = message
        self.details = details
        self.selectedIDs = selectedIDs
        self.action = action
        self.cancel = cancel
        self.submitLabel = submitLabel
        self.cancelLabel = cancelLabel
        self.hiddenFields = hiddenFields
    }

    public func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(state: breadcrumb))
            H1(title)
            P(message)
            for detail in details { P(detail) }
            if !selectedIDs.isEmpty {
                P("Selected \(selectedIDs.count) items.")
                P("IDs: \(selectedIDs.prefix(10).joined(separator: ", "))")
            }
            Form {
                for field in hiddenFields {
                    Input()
                        .type(.hidden)
                        .name(field.name)
                        .value(field.value)
                }
                context.render(
                    NewAdminSubmitButton(submitLabel, style: .destructive)
                )
                context.render(
                    NewAdminButton(
                        cancelLabel,
                        href: cancel,
                        style: .ghost(.primary)
                    )
                )
            }
            .method(.post)
            .action(action)
            .class("button-row")
        }
        .class("cms-section")
    }
}
