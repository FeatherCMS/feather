public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct AdminDetailView: Component {
    public struct Field: Sendable {
        public struct Chip: Sendable {
            public let label: String
            public let color: AdminChip.ColorName

            public init(label: String, color: AdminChip.ColorName) {
                self.label = label
                self.color = color
            }
        }

        public let label: String
        public let value: String
        public let chip: Chip?
        public let chips: [Chip]?
        public let imageURL: String?

        public init(label: String, value: String) {
            self.label = label
            self.value = value
            self.chip = nil
            self.chips = nil
            self.imageURL = nil
        }

        public init(label: String, chip: Chip) {
            self.label = label
            self.value = ""
            self.chip = chip
            self.chips = nil
            self.imageURL = nil
        }

        public init(label: String, chips: [Chip]) {
            self.label = label
            self.value = ""
            self.chip = nil
            self.chips = chips
            self.imageURL = nil
        }

        public init(label: String, imageURL: String) {
            self.label = label
            self.value = ""
            self.chip = nil
            self.chips = nil
            self.imageURL = imageURL
        }
    }
    public struct Action: Sendable {
        public let label: String
        public let href: String
        public let style: AdminButtonStyle
        public init(label: String, href: String, style: AdminButtonStyle) {
            self.label = label
            self.href = href
            self.style = style
        }
    }
    public let breadcrumb: [AdminBreadcrumb.Link]
    public let pageHeader: AdminPageHeader.State
    public let fields: [Field]
    public let actions: [Action]
    public init(
        breadcrumb: [AdminBreadcrumb.Link],
        pageHeader: AdminPageHeader.State,
        fields: [Field],
        actions: [Action] = []
    ) {
        self.breadcrumb = breadcrumb
        self.pageHeader = pageHeader
        self.fields = fields
        self.actions = actions
    }
    public func html(context: inout BuilderContext) -> Section {
        Section {
            context.build(AdminBreadcrumb(links: breadcrumb))
            context.build(AdminPageHeader(state: pageHeader))
            Div {
                for field in fields {
                    Div {
                        P(field.label).class("admin-detail-view-field-label")
                        if let imageURL = field.imageURL {
                            Img(src: imageURL, alt: field.label)
                                .class(
                                    "admin-detail-view-field-image"
                                )
                        }
                        else if let chips = field.chips {
                            Div {
                                for chip in chips {
                                    context.build(
                                        AdminChip(
                                            label: chip.label,
                                            color: chip.color
                                        )
                                    )
                                }
                            }
                            .class("admin-detail-view-field-chips")
                        }
                        else if let chip = field.chip {
                            context.build(
                                AdminChip(
                                    label: chip.label,
                                    color: chip.color
                                )
                            )
                        }
                        else {
                            P(field.value)
                                .class(
                                    "admin-detail-view-field-value"
                                )
                        }
                    }
                    .class("admin-detail-view-field")
                }
            }
            .class("admin-detail-view-fields")
            if !actions.isEmpty {
                Div {
                    for action in actions {
                        context.build(
                            AdminButton(
                                action.label,
                                href: action.href,
                                style: action.style
                            )
                        )
                    }
                }
                .class("admin-detail-actions")
            }
        }
        .class("cms-section")
    }

    public func rules() -> [any Rule] {
        Media {
            Custom(".admin-detail-view-fields") {
                Display(.grid)
                Gap(12.px)
            }
            Custom(".admin-detail-view-field") {
                Padding(vertical: 12.px)
            }
            Custom(".admin-detail-view-field-label") {
                Margin(0)
                Margin(bottom: 8.px)
                Padding(bottom: 8.px)
                BorderBottom(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                FontWeight(.normal)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Opacity(0.8)
            }
            Custom(".admin-detail-view-field-value") {
                Margin(top: 6.px)
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
            }
            Custom(".admin-detail-view-field-chips") {
                Display(.flex)
                FlexWrap(.wrap)
                Gap(8.px)
                Margin(top: 6.px)
            }
            Custom(".admin-detail-view-field-image") {
                Display(.block)
                Width(96.px)
                Height(96.px)
                ObjectFit(.cover)
                BorderRadius(50.percent)
                Margin(top: 6.px)
            }
            Custom(".admin-detail-actions") {
                Display(.flex)
                FlexWrap(.wrap)
                Gap(12.px)
                Margin(top: 24.px)
            }
        }
    }
}
