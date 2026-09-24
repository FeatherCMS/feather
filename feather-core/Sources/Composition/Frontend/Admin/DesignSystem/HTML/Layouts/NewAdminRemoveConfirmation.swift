public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminRemoveConfirmation: Component {
    public struct HiddenField: Sendable {
        public let name: String
        public let value: String

        public init(name: String, value: String) {
            self.name = name
            self.value = value
        }
    }

    public let breadcrumb: [NewAdminBreadcrumb.Link]
    public let pageHeader: NewAdminPageHeader.State
    public let selectedItems: [String]
    public let action: String
    public let cancel: String
    public let submitLabel: String
    public let cancelLabel: String
    public let nonceToken: String?
    public let hiddenFields: [HiddenField]
    public let tabBar: NewAdminTabBar?
    public let sectionTitle: String?
    public let sectionDescription: String?
    public let sectionHeader: NewAdminPageHeader.State?
    public let contentClass: String?

    public init(
        breadcrumb: [NewAdminBreadcrumb.Link],
        pageHeader: NewAdminPageHeader.State,
        selectedItems: [String] = [],
        action: String,
        cancel: String,
        submitLabel: String = "Remove",
        cancelLabel: String = "Cancel",
        nonceToken: String? = nil,
        hiddenFields: [HiddenField] = [],
        tabBar: NewAdminTabBar? = nil,
        sectionTitle: String? = nil,
        sectionDescription: String? = nil,
        sectionHeader: NewAdminPageHeader.State? = nil,
        contentClass: String? = nil
    ) {
        self.breadcrumb = breadcrumb
        self.pageHeader = pageHeader
        self.selectedItems = selectedItems
        self.action = action
        self.cancel = cancel
        self.submitLabel = submitLabel
        self.cancelLabel = cancelLabel
        self.nonceToken = nonceToken
        self.hiddenFields = hiddenFields
        self.tabBar = tabBar
        self.sectionTitle = sectionTitle
        self.sectionDescription = sectionDescription
        self.sectionHeader = sectionHeader
        self.contentClass = contentClass
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
        Section {
            context.build(NewAdminBreadcrumb(links: breadcrumb))
            context.build(NewAdminPageHeader(state: pageHeader))
            if let tabBar {
                context.build(tabBar)
            }
            Div {
                if let sectionHeader {
                    context.build(NewAdminPageHeader(state: sectionHeader))
                }
                else if let sectionTitle {
                    H2(sectionTitle)
                    if let sectionDescription {
                        P(sectionDescription)
                    }
                }
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
                    context.build(
                        NewAdminSubmitButton(submitLabel, style: .destructive)
                    )
                    context.build(
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
            .if(contentClass != nil) { $0.class(contentClass ?? "") }
        }
        .class("cms-section")
    }
}
