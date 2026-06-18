import HTML
import SGML
import WebStandards

struct BlogTagDetails: Component {
    struct State {
        let rule: BlogTagDetailsModel
        let breadcrumb: AdminBreadcrumb.State
        let permissions: Set<String>
        let isPublished: Bool
        let isUnpublished: Bool
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Blog tag details")
            if state.isPublished {
                P("Blog tag published successfully.")
            }
            if state.isUnpublished {
                P("Blog tag unpublished successfully.")
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
                    AdminBlog.Scope.tags.permission(for: .update)
                ) {
                    AdminStatusActionForm(
                        action: "/admin/blog/tags/\(state.rule.id)/status/",
                        returnTo: "/admin/blog/tags/\(state.rule.id)/",
                        status: isPublished ? "draft" : "published",
                        label: isPublished ? "Unpublish" : "Publish",
                        classes: ["secondary"]
                    )
                    AdminNavigationButton(
                        "Edit tag",
                        href: "/admin/blog/tags/\(state.rule.id)/edit/"
                    )
                }
                if state.permissions.contains(
                    AdminBlog.Scope.tags.permission(for: .delete)
                ) {
                    AdminNavigationButton(
                        "Remove tag",
                        href: "/admin/blog/tags/\(state.rule.id)/remove/",
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
