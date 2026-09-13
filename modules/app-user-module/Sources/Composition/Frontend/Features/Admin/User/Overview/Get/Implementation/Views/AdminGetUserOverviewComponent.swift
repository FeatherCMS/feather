import CSS
import FeatherAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct AdminGetUserOverviewComponent: Component {
    struct Destination {
        let title: String
        let description: String
        let href: String
        let icon: String
    }

    private let destinations = [
        Destination(title: "User identities", description: "Manage identities and their assigned roles.", href: UserIdentityRoutes.list.description, icon: "users"),
        Destination(title: "User roles", description: "Manage roles assigned to user identities.", href: UserRoleRoutes.list.description, icon: "shield"),
    ]

    func rules() -> [any Rule] {
        Media {
            Custom(".user-overview-destinations") { Margin(top: 8.px); RowGap(16.px); ColumnGap(16.px) }
            Custom(".user-overview-destination") {
                Display(.flex); FlexDirection(.column); AlignItems(.flexStart); Gap(12.px); Padding(24.px)
                Border(1.px, .solid, .variable(TokenKey.Colors.Materials.Tertiary.border))
                BorderRadius(12.px); Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            }
            Custom(".user-overview-destination h2, .user-overview-destination p") { Margin(0) }
            Custom(".user-overview-destination h2 + p") { Margin(top: (-6).px) }
            Custom(".user-overview-destination p") { Color(.variable(TokenKey.Colors.Materials.Tertiary.text)); LineHeight(1.5) }
            Custom(".user-overview-destination .new-admin-button") { Margin(top: 4.px) }
        }
    }

    func html(context: inout RenderContext) -> Section {
        Section {
            context.render(NewAdminBreadcrumb(links: [
                .init(label: "Admin", link: "/admin/"),
            ]))
            context.render(NewAdminPageHeader(state: .init(title: "User", description: "Manage user identities, roles, and access.")))
            Div {
                for destination in destinations {
                    Div {
                        if let icon = FeatherIcons.get(named: destination.icon) { icon }
                        H2(destination.title)
                        P(destination.description)
                        context.render(NewAdminButton("Open", href: destination.href, style: .primary))
                    }.class("user-overview-destination")
                }
            }.class("grid grid-221 user-overview-destinations")
        }.class("cms-section")
    }
}
