import HTML
import SGML
import WebStandards

struct BlogPostDetails: Component {
    struct State {
        let rule: BlogPostDetailsModel
        let breadcrumb: AdminBreadcrumb.State
        let permissions: Set<String>
        let isPublished: Bool
        let isUnpublished: Bool
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Blog post details")
            if state.isPublished {
                P("Blog post published successfully.")
            }
            if state.isUnpublished {
                P("Blog post unpublished successfully.")
            }
            AdminDetailsField(label: "ID", value: state.rule.id)
            AdminDetailsField(label: "Title", value: state.rule.title)
            AdminDetailsField(
                label: "Status",
                value: state.rule.metadata.status.capitalized
            )
            AdminDetailsField(
                label: "Published date",
                value: format(state.rule.metadata.publicationDate)
            )
            AdminDetailsField(
                label: "Expiration date",
                value: format(state.rule.metadata.expirationDate)
            )
            AdminDetailsField(
                label: "Authors",
                value: state.rule.authorIds.isEmpty
                    ? "None" : state.rule.authorIds.joined(separator: ", ")
            )
            AdminDetailsField(
                label: "Tags",
                value: state.rule.tagIds.isEmpty
                    ? "None" : state.rule.tagIds.joined(separator: ", ")
            )
            H2("Content")
            Pre { state.rule.content }
            Div {
                if let previewPath = previewPath {
                    A("Preview")
                        .href(previewPath)
                        .setAttribute(name: "target", value: "_blank")
                        .class("secondary")
                }
                if state.permissions.contains(
                    AdminBlog.Scope.posts.permission(for: .update)
                ) {
                    AdminStatusActionForm(
                        action: "/admin/blog/posts/\(state.rule.id)/status/",
                        returnTo: "/admin/blog/posts/\(state.rule.id)/",
                        status: isPublished ? "draft" : "published",
                        label: isPublished ? "Unpublish" : "Publish",
                        classes: ["secondary"]
                    )
                    AdminNavigationButton(
                        "Edit post",
                        href: "/admin/blog/posts/\(state.rule.id)/edit/"
                    )
                }
                if state.permissions.contains(
                    AdminBlog.Scope.posts.permission(for: .delete)
                ) {
                    AdminNavigationButton(
                        "Remove post",
                        href: "/admin/blog/posts/\(state.rule.id)/remove/",
                        classes: ["danger"]
                    )
                }
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }

    private var isPublished: Bool {
        state.rule.metadata.normalizedStatus == "published"
    }

    private var previewPath: String? {
        let slug = state.rule.metadata.normalizedSlug
        return slug.isEmpty ? nil : "/\(slug)/"
    }

    private func format(
        _ value: String
    ) -> String {
        guard let timestamp = AdminMetadataSchemaBuilder.parseTimestamp(value)
        else {
            return "-"
        }
        return DateFormatting.formatUnixTimestamp(timestamp)
    }
}
