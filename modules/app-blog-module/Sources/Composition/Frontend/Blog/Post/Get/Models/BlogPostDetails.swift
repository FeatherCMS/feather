import BlogAdminAPI
import BlogAppAPI
import BlogContracts
import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

struct BlogPostDetails: Leaf {
    struct State {
        let rule: BlogPostDetailsModel
        let breadcrumb: AdminBreadcrumb.State
        let permissions: Set<String>
        let isPublished: Bool
        let isUnpublished: Bool
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("Blog post details")
            if state.isPublished {
                P("Blog post published successfully.")
            }
            if state.isUnpublished {
                P("Blog post unpublished successfully.")
            }
            AdminDetailsField(label: "ID", value: state.rule.id).renderHTML()
            AdminDetailsField(label: "Title", value: state.rule.title).renderHTML()
            AdminDetailsField(
                label: "Status",
                value: state.rule.metadata.status.capitalized
            ).renderHTML()
            AdminDetailsField(
                label: "Published date",
                value: format(state.rule.metadata.publicationDate)
            ).renderHTML()
            AdminDetailsField(
                label: "Expiration date",
                value: format(state.rule.metadata.expirationDate)
            ).renderHTML()
            AdminDetailsField(
                label: "Authors",
                value: state.rule.authorIds.isEmpty
                    ? "None" : state.rule.authorIds.joined(separator: ", ")
            ).renderHTML()
            AdminDetailsField(
                label: "Tags",
                value: state.rule.tagIds.isEmpty
                    ? "None" : state.rule.tagIds.joined(separator: ", ")
            ).renderHTML()
            H2("Content")
            Pre { state.rule.content }
            Div {
                if let previewPath = previewPath {
                    A("Preview")
                        .href(previewPath)
                        .target(.blank)
                        .class("secondary")
                }
                if state.permissions.contains(
                    BlogPermissions.Posts.update.rawValue
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
                    ).renderHTML()
                }
                if state.permissions.contains(
                    BlogPermissions.Posts.delete.rawValue
                ) {
                    AdminNavigationButton(
                        "Remove post",
                        href: "/admin/blog/posts/\(state.rule.id)/remove/",
                        classes: ["danger"]
                    ).renderHTML()
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
        return DateFormatting.formatUnixTimestamp(
            timestamp
        )
    }
}
