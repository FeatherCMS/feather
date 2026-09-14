import BlogAdminAPI
import BlogAppAPI
import BlogContracts
import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct BlogPostDetails: Component {
    struct State {
        let rule: BlogPostDetailsModel
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let permissions: Set<String>
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(
                NewAdminDetailView(
                    breadcrumb: state.breadcrumb,
                    pageHeader: .init(
                        title: "Blog post details",
                        description: "Review the blog post configuration."
                    ),
                    fields: [
                        .init(label: "ID", value: state.rule.id),
                        .init(label: "Title", value: state.rule.title),
                        .init(
                            label: "Status",
                            value: state.rule.metadata.status.capitalized
                        ),
                        .init(
                            label: "Published date",
                            value: format(state.rule.metadata.publicationDate)
                        ),
                        .init(
                            label: "Expiration date",
                            value: format(state.rule.metadata.expirationDate)
                        ),
                        .init(
                            label: "Authors",
                            value: state.rule.authorIds.isEmpty
                                ? "None"
                                : state.rule.authorIds.joined(separator: ", ")
                        ),
                        .init(
                            label: "Tags",
                            value: state.rule.tagIds.isEmpty
                                ? "None"
                                : state.rule.tagIds.joined(separator: ", ")
                        ),
                        .init(label: "Content", value: state.rule.content),
                    ],
                    actions: actions
                )
            )
            if state.permissions.contains(BlogPermissions.Posts.update.rawValue)
            {
                let formID = "blog-post-status-\(state.rule.id)"
                Div {
                    context.render(
                        NewAdminStatusSelectFormDefinition(
                            id: formID,
                            action:
                                BlogAdminRoutes.postStatus(
                                    RouterPath(state.rule.id)
                                )
                                .description,
                            returnTo:
                                BlogAdminRoutes.post(RouterPath(state.rule.id))
                                .description
                        )
                    )
                    context.render(
                        NewAdminStatusSelectField(
                            formID: formID,
                            selectedStatus: state.rule.metadata.normalizedStatus
                        )
                    )
                }
                .class("new-admin-detail-actions")
            }
        }
        .class("cms-section")
    }

    private var actions: [NewAdminDetailView.Action] {
        var result: [NewAdminDetailView.Action] = []
        if state.permissions.contains(BlogPermissions.Posts.update.rawValue) {
            result.append(
                .init(
                    label: "Edit post",
                    href: BlogAdminRoutes.postEdit(RouterPath(state.rule.id))
                        .description,
                    style: .primary
                )
            )
        }
        if state.permissions.contains(BlogPermissions.Posts.delete.rawValue) {
            result.append(
                .init(
                    label: "Remove post",
                    href: BlogAdminRoutes.postRemove(RouterPath(state.rule.id))
                        .description,
                    style: .destructive
                )
            )
        }
        return result
    }

    private func format(_ value: String) -> String {
        guard let timestamp = AdminMetadataSchemaBuilder.parseTimestamp(value)
        else { return "-" }
        return DateFormatting.formatUnixTimestamp(timestamp)
    }
}
