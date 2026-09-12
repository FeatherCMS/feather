import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminDetailView: Component {
    public struct Field: Sendable {
        public let label: String
        public let value: String
        public init(label: String, value: String) {
            self.label = label
            self.value = value
        }
    }
    public struct Action: Sendable {
        public let label: String
        public let href: String
        public let style: NewAdminButtonStyle
        public init(label: String, href: String, style: NewAdminButtonStyle) {
            self.label = label
            self.href = href
            self.style = style
        }
    }
    public let breadcrumb: NewAdminBreadcrumb.State
    public let pageHeader: NewAdminPageHeader.State
    public let fields: [Field]
    public let actions: [Action]
    public init(
        breadcrumb: NewAdminBreadcrumb.State,
        pageHeader: NewAdminPageHeader.State,
        fields: [Field],
        actions: [Action] = []
    ) {
        self.breadcrumb = breadcrumb
        self.pageHeader = pageHeader
        self.fields = fields
        self.actions = actions
    }
    public func html(context: inout RenderContext) -> Section {
        Section {
            context.render(NewAdminBreadcrumb(state: breadcrumb))
            context.render(NewAdminPageHeader(state: pageHeader))
            Div {
                for field in fields {
                    Div {
                        P(field.label).class("admin-detail-view-field-label")
                        P(field.value).class("admin-detail-view-field-value")
                    }
                    .class("admin-detail-view-field")
                }
            }
            .class("admin-detail-view-fields")
            if !actions.isEmpty {
                Div {
                    for action in actions {
                        context.render(
                            NewAdminButton(
                                action.label,
                                href: action.href,
                                style: action.style
                            )
                        )
                    }
                }
                .class("new-admin-detail-actions")
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
                Padding(0.px)
            }
            Custom(".admin-detail-view-field-label") {
                Margin(0)
                FontWeight(.normal)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Opacity(0.8)
            }
            Custom(".admin-detail-view-field-value") {
                Margin(top: 6.px)
                Padding(vertical: 10.px, horizontal: 12.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Secondary.border)
                )
                BorderRadius(6.px)
            }
            Custom(".new-admin-detail-actions") {
                Display(.flex)
                FlexWrap(.wrap)
                Gap(12.px)
                Margin(top: 24.px)
            }
        }
    }
}
