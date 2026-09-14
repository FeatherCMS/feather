import CSS
import FeatherAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct AdminViewContactOverviewComponent: Component {
    struct Destination {
        let title: String
        let description: String
        let href: String
        let icon: String
    }

    private let destinations = [
        Destination(
            title: "Forms",
            description: "Manage contact forms and their configuration.",
            href: ContactAdminRoutes.forms.description,
            icon: "clipboard"
        ),
        Destination(
            title: "Fields",
            description: "Manage reusable fields for contact forms.",
            href: ContactAdminRoutes.fields.description,
            icon: "list"
        ),
        Destination(
            title: "Submissions",
            description: "Review and manage submitted contact messages.",
            href: ContactAdminRoutes.submissions.description,
            icon: "inbox"
        ),
    ]

    func rules() -> [any Rule] {
        Media {
            Custom(".contact-overview-destinations") {
                Margin(top: 8.px)
                RowGap(16.px)
                ColumnGap(16.px)
            }
            Custom(".contact-overview-destination") {
                Display(.flex)
                FlexDirection(.column)
                AlignItems(.flexStart)
                Gap(12.px)
                Padding(24.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(12.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            }
            Custom(
                ".contact-overview-destination h2, .contact-overview-destination p"
            ) { Margin(0) }
            Custom(".contact-overview-destination h2 + p") {
                Margin(top: (-6).px)
            }
            Custom(".contact-overview-destination p") {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                LineHeight(1.5)
            }
            Custom(".contact-overview-destination .new-admin-button") {
                Margin(top: 4.px)
            }
        }
    }

    func html(context: inout RenderContext) -> Section {
        Section {
            context.render(
                NewAdminBreadcrumb(links: [
                    .init(label: "Admin", link: ContactAdminRoutes.admin.description + "/")
                ])
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Contact",
                        description:
                            "Manage contact forms, fields, and submissions."
                    )
                )
            )
            Div {
                for destination in destinations {
                    Div {
                        if let icon = FeatherIcons.get(named: destination.icon)
                        {
                            icon
                        }
                        H2(destination.title)
                        P(destination.description)
                        context.render(
                            NewAdminButton(
                                "Open",
                                href: destination.href,
                                style: .primary
                            )
                        )
                    }
                    .class("contact-overview-destination")
                }
            }
            .class("grid grid-221 contact-overview-destinations")
        }
        .class("cms-section")
    }
}
