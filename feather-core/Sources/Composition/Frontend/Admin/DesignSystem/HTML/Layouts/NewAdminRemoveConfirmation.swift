public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminRemoveConfirmation: Component {
    public typealias ButtonState = NewAdminButton.State

    public let pageHeader: NewAdminPageHeader.State
    public let selectedItems: [String]
    public let action: String
    public let submit: ButtonState
    public let cancel: ButtonState
    public let nonceToken: String?
    public let hiddenFields: [NewAdminFormFieldHiddenValue]
    public let relationshipGroupHeader: NewAdminPageHeader.State?

    public init(
        pageHeader: NewAdminPageHeader.State,
        selectedItems: [String] = [],
        action: String,
        submit: ButtonState = .init(label: "Remove", style: .destructive),
        cancel: ButtonState = .init(
            label: "Cancel",
            style: .ghost(.primary)
        ),
        nonceToken: String? = nil,
        hiddenFields: [NewAdminFormFieldHiddenValue] = [],
        relationshipGroupHeader: NewAdminPageHeader.State? = nil
    ) {
        self.pageHeader = pageHeader
        self.selectedItems = selectedItems
        self.action = action
        self.submit = submit
        self.cancel = cancel
        self.nonceToken = nonceToken
        self.hiddenFields = hiddenFields
        self.relationshipGroupHeader = relationshipGroupHeader
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
                    context.build(NewAdminButton(state: submit))
                }
                else {
                    context.build(NewAdminSubmitButton(state: submit))
                }
                if cancel.href != nil {
                    context.build(NewAdminButton(state: cancel))
                }
                else {
                    context.build(
                        NewAdminControlButton(state: cancel)
                    )
                    .data("admin-dialog-close", "")
                }
            }
            .method(.post)
            .action(action)
            .class("button-row")
        }

        return Section {
            context.build(NewAdminPageHeader(state: pageHeader))
            if let relationshipGroupHeader {
                context.build(
                    NewAdminRelationshipGroup(
                        pageHeader: relationshipGroupHeader
                    ) {
                        content
                    }
                )
            }
            else {
                content
            }
        }
        .class("cms-section")
    }
}
