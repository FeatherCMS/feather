import CSS
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebDomain
import WebModule

extension MenuItem.View {
    struct Page: WebComponents.Component {
        struct State {
            let item: Model
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: MenuItem.Router.Routes
        }

        let state: State

        func selectors() -> [any CSS.Selector] {
            [
                Custom(".web-menu-item-details-fields") {
                    Display(.grid)
                    Gap(12.px)
                },
                Custom(".web-menu-item-details-field") {
                    Padding(vertical: 12.px)
                },
                Custom(".web-menu-item-details-field-label") {
                    Margin(0)
                    Padding(bottom: 8.px)
                    BorderBottom(
                        1.px,
                        .solid,
                        .variable(TokenKey.Colors.Materials.Tertiary.border)
                    )
                    FontWeight(.normal)
                    Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                    Opacity(0.8)
                },
                Custom(".web-menu-item-details-field-value") {
                    Margin(top: 6.px)
                    Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                },
                Custom(".web-menu-item-details-actions") {
                    Display(.flex)
                    FlexWrap(.wrap)
                    Gap(12.px)
                    Margin(top: 24.px)
                },
            ]
        }

        func html(context: inout BuilderContext) -> Section {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit menu",
                            description:
                                "Update the navigation menu configuration."
                        )
                    )
                )
                context.build(
                    MenuItem.TabBar(
                        active: .items,
                        detailsPath: state.routes.menu.editPath(
                            state.item.menuId
                        ),
                        itemsPath: state.routes.itemsPath(state.item.menuId)
                    )
                )
                context.build(
                    AdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "View item",
                            description: "Review the navigation menu link."
                        )
                    ) {
                        Div {
                            detailField(
                                label: "Label",
                                value: state.item.label,
                                isRemovalLabel: true
                            )
                            detailField(label: "URL", value: state.item.url)
                            detailField(
                                label: "Priority",
                                value: "\(state.item.priority)"
                            )
                            detailField(
                                label: "Blank target",
                                value: state.item.isBlank ? "Yes" : "No"
                            )
                            detailField(
                                label: "Permission",
                                value: state.item.permission
                            )
                            detailField(
                                label: "Authentication",
                                value: state.item.authentication
                            )
                            detailField(
                                label: "Notes",
                                value: state.item.notes ?? "—"
                            )
                        }
                        .class("web-menu-item-details-fields")
                        Div {
                            context.build(
                                AdminButton(
                                    "Edit item",
                                    href: state.routes.itemEditPath(
                                        menuID: state.item.menuId,
                                        itemID: state.item.id
                                    ),
                                    style: .primary
                                )
                            )
                            let button = AdminButton(
                                "Remove item",
                                href: state.routes.itemRemovePath(
                                    menuID: state.item.menuId,
                                    itemID: state.item.id,
                                    origin: .view
                                ),
                                style: .destructive,
                            )
                            context.build(button)
                        }
                        .class("web-menu-item-details-actions")
                    }
                )
            }
            .class("cms-section")
        }

        private func detailField(
            label: String,
            value: String,
            isRemovalLabel: Bool = false
        ) -> Div {
            Div {
                P(label).class("web-menu-item-details-field-label")
                let valueView = P(value)
                    .class("web-menu-item-details-field-value")
                if isRemovalLabel {
                    valueView.setAsRemoveConfirmationLabel()
                }
                else {
                    valueView
                }
            }
            .class("web-menu-item-details-field")
        }
    }
}
