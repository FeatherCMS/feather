import CSS
import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AdminGetSystemOverviewComponent: Component {
    struct Destination { let title: String; let description: String; let href: String }
    private let destinations = [
        Destination(title: "Variables", description: "Manage application configuration values.", href: "/admin/system/variables/"),
        Destination(title: "Permissions", description: "Manage system access permissions.", href: "/admin/system/permissions/"),
        Destination(title: "Worker jobs", description: "Inspect queued and completed background jobs.", href: "/admin/system/jobs/"),
        Destination(title: "Design system", description: "Explore the admin interface materials and components.", href: "/admin/system/design-system/")
    ]

    func rules() -> [any Rule] {
        Media {
            Custom(".system-home-destinations") {
                Display(.flex); FlexWrap(.wrap); Gap(16.px); Margin(top: 28.px)
            }
            Custom(".system-home-destination") {
                Display(.flex); FlexDirection(.column); AlignItems(.flexStart); Gap(10.px); Padding(20.px)
                Border(1.px, .solid, .variable(TokenKey.Colors.Materials.Tertiary.border)); BorderRadius(10.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                Width(100.percent)
            }
            Custom(".system-home-destination h2, .system-home-destination p") { Margin(0) }
        }
        Media(.minWidth(701.px)) { Custom(".system-home-destination") { Width(45.percent) } }
    }

    func html(context: inout RenderContext) -> Section {
        Section {
            context.render(NewAdminBreadcrumb(state: .init(links: [
                .init(label: "Admin", link: "/admin/"), .init(label: "System", link: "/admin/system/")
            ])))
            context.render(NewAdminPageHeader(state: .init(title: "System", description: "Manage core system configuration and administration tools.")))
            Div {
                for destination in destinations {
                    Div {
                        H2(destination.title); P(destination.description)
                        context.render(NewAdminButton("Open", href: destination.href, style: .secondary))
                    }.class("system-home-destination")
                }
            }.class("system-home-destinations")
        }.class("cms-section")
    }
}
