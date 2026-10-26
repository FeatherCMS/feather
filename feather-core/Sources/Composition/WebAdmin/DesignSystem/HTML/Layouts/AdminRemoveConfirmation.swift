public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct AdminRemoveConfirmation: Component {
    public static let dialogTitle = "Are you sure?"

    public let selectedItems: [String]
    public let action: String
    public let submit: AdminButton.State
    public let cancel: AdminButton.State
    public let nonceToken: String?
    public let hiddenFields: [AdminFormFieldHiddenValue]
    public let header: AdminPageHeader.State

    public init(
        header: AdminPageHeader.State,
        selectedItems: [String] = [],
        action: String,
        submit: AdminButton.State = .init(
            label: "Remove",
            style: .destructive
        ),
        cancel: AdminButton.State = .init(
            label: "Cancel",
            style: .ghost(.primary)
        ),
        nonceToken: String? = nil,
        hiddenFields: [AdminFormFieldHiddenValue] = []
    ) {
        self.selectedItems = selectedItems
        self.action = action
        self.submit = submit
        self.cancel = cancel
        self.nonceToken = nonceToken
        self.hiddenFields = hiddenFields
        self.header = header
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
            Custom(".admin-remove-confirmation-actions") {
                Display(.flex)
                AlignItems(.center)
                Gap(12.px)
            }
        }
    }

    public func html(context: inout BuilderContext) -> Section {
        let content = Div {
            if !selectedItems.isEmpty {
                Div {
                    Ul {
                        for item in selectedItems.prefix(20) { Li(item) }
                        if selectedItems.count > 20 {
                            Li("And \(selectedItems.count - 20) more.")
                        }
                    }
                }
                .class("admin-confirmation-items")
            }
            Form {
                if let nonceToken {
                    Input().type(.hidden).name("_nonce").value(nonceToken)
                }
                for field in hiddenFields {
                    Input()
                        .type(.hidden)
                        .name(field.name)
                        .value(field.value)
                }
                if submit.href != nil {
                    context.build(AdminButton(state: submit))
                }
                else {
                    context.build(AdminSubmitButton(state: submit))
                }
                if cancel.href != nil {
                    context.build(AdminButton(state: cancel))
                }
                else {
                    context.build(
                        AdminControlButton(state: cancel)
                    )
                    .data("admin-dialog-close", "")
                }
            }
            .method(.post)
            .action(action)
            .class("button-row", "admin-remove-confirmation-actions")
        }

        return Section {
            context.build(
                AdminRelationshipGroup(
                    pageHeader: header
                ) {
                    content
                }
            )
        }
        .class("cms-section")
    }
}
