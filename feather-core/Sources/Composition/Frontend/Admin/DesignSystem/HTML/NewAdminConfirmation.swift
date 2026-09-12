import CSS
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
    public let selectedIDs: [String]
    public let selectedNames: [String]
    public let action: String
    public let cancel: String
    public let submitLabel: String
    public let cancelLabel: String
    public let hiddenFields: [HiddenField]

    public init(
        breadcrumb: NewAdminBreadcrumb.State,
        title: String,
        message: String,
        selectedIDs: [String] = [],
        selectedNames: [String] = [],
        action: String,
        cancel: String,
        submitLabel: String = "Remove",
        cancelLabel: String = "Cancel",
        hiddenFields: [HiddenField] = []
    ) {
        self.breadcrumb = breadcrumb
        self.title = title
        self.message = message
        self.selectedIDs = selectedIDs
        self.selectedNames = selectedNames
        self.action = action
        self.cancel = cancel
        self.submitLabel = submitLabel
        self.cancelLabel = cancelLabel
        self.hiddenFields = hiddenFields
    }

    @Builder<CSS.Rule>
    public func rules() -> [any Rule] {
        Media {
            Custom(".admin-confirmation-items") {
                Margin(vertical: 20.px, horizontal: 0.px)
                Padding(vertical: 16.px, horizontal: 20.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(8.px)
            }
            Custom(".admin-confirmation-items p") { Margin(0) }
            Custom(".admin-confirmation-items ul") {
                Margin(vertical: 12.px, horizontal: 0.px)
                Padding(left: 20.px)
            }
            Custom(".admin-confirmation-items li") {
                Margin(vertical: 8.px, horizontal: 0.px)
            }
        }
    }

    public func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(state: breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(title: title, description: message)
                )
            )
            if !selectedNames.isEmpty {
                Div {
                    Ul {
                        for name in selectedNames.prefix(20) { Li(name) }
                        if selectedNames.count > 20 {
                            Li("And \(selectedNames.count - 20) more.")
                        }
                    }
                }
                .class("admin-confirmation-items")
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
