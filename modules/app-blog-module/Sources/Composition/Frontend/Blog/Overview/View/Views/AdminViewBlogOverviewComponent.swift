import CSS
import FeatherAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct AdminViewBlogOverviewComponent: Component {
    struct Destination {
        let title: String
        let description: String
        let href: String
        let icon: String
    }

    private let destinations = [
        Destination(
            title: "Posts",
            description: "Manage blog posts and their publication state.",
            href: "/admin/blog/posts/",
            icon: "fileText"
        ),
        Destination(
            title: "Authors",
            description: "Manage the authors available to blog posts.",
            href: "/admin/blog/authors/",
            icon: "users"
        ),
        Destination(
            title: "Tags",
            description: "Manage tags used to organize blog posts.",
            href: "/admin/blog/tags/",
            icon: "tag"
        ),
        Destination(
            title: "Settings",
            description: "Manage the blog settings.",
            href: "/admin/blog/settings/",
            icon: "settings"
        ),
    ]

    func rules() -> [any Rule] {
        Media {
            Custom(".blog-overview-destinations") {
                Margin(top: 8.px)
                RowGap(16.px)
                ColumnGap(16.px)
            }
            Custom(".blog-overview-destination") {
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
                ".blog-overview-destination h2, .blog-overview-destination p"
            ) { Margin(0) }
            Custom(".blog-overview-destination h2 + p") {
                Margin(top: (-6).px)
            }
            Custom(".blog-overview-destination p") {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                LineHeight(1.5)
            }
            Custom(".blog-overview-destination .new-admin-button") {
                Margin(top: 4.px)
            }
        }
    }

    func html(context: inout RenderContext) -> Section {
        Section {
            context.render(
                NewAdminBreadcrumb(links: [
                    .init(label: "Admin", link: "/admin/")
                ])
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Blog",
                        description:
                            "Manage blog posts, authors, tags, and settings."
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
                    .class("blog-overview-destination")
                }
            }
            .class("grid grid-221 blog-overview-destinations")
        }
        .class("cms-section")
    }
}
