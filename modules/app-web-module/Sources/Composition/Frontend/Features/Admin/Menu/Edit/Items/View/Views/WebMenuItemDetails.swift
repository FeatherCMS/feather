import CSS
import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct WebMenuItemDetails: Component {
    struct State {
        let item: WebMenuItemDetailsModel
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func selectors() -> [any CSS.Selector] {
        WebMenuItemGroup.groupSelectors()
            + [
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
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit menu",
                        description:
                            "Update the navigation menu configuration."
                    )
                )
            )
            context.build(
                AdminWebMenuTabs(
                    menuID: state.item.menuId,
                    active: .items
                )
            )
            context.build(
                WebMenuItemGroup {
                    context.build(
                        NewAdminPageHeader(
                            state: .init(
                                title: "View item",
                                description:
                                    "Review the navigation menu link.",
                                level: 2,
                                showSeparator: true
                            )
                        )
                    )
                    Div {
                        detailField(label: "ID", value: state.item.id)
                        detailField(label: "Label", value: state.item.label)
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
                            NewAdminButton(
                                "Edit item",
                                href: WebMenuItemRoutes.edit(
                                    RouterPath(state.item.menuId),
                                    RouterPath(state.item.id)
                                ).description,
                                style: .primary
                            )
                        )
                        context.build(
                            NewAdminButton(
                                "Remove item",
                                href: WebMenuItemRoutes.itemRemove(
                                    RouterPath(state.item.menuId),
                                    RouterPath(state.item.id),
                                    origin: .view
                                ),
                                style: .destructive
                            )
                        )
                    }
                    .class("web-menu-item-details-actions")
                }
            )
        }
        .class("cms-section")
    }

    private func detailField(label: String, value: String) -> Div {
        Div {
            P(label).class("web-menu-item-details-field-label")
            P(value).class("web-menu-item-details-field-value")
        }
        .class("web-menu-item-details-field")
    }
}
