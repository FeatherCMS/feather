import BlogAdminAPI
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

struct BlogTagDetails: Component {
    struct State {
        let rule: BlogTagDetailsModel
        let breadcrumb: [AdminBreadcrumb.Link]
        let permissions: Set<String>
    }
    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminDetailView(
                    breadcrumb: state.breadcrumb,
                    pageHeader: .primary(
                        title: "Blog tag details",
                        description: "Review the blog tag configuration."
                    ),
                    fields: [
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
                        .init(label: "Content", value: state.rule.content),
                    ],
                    actions: actions
                )
            )
            if state.permissions.contains(BlogPermissions.Tags.update.rawValue)
            {
                let formID = "blog-tag-status-\(state.rule.id)"
                Div {
                    context.build(
                        AdminStatusSelectFormDefinition(
                            id: formID,
                            action:
                                BlogAdminRoutes.tagStatus(
                                    RouterPath(state.rule.id)
                                )
                                .description,
                            returnTo:
                                BlogAdminRoutes.tag(RouterPath(state.rule.id))
                                .description
                        )
                    )
                    context.build(
                        AdminStatusSelectField(
                            formID: formID,
                            selectedStatus: state.rule.metadata.normalizedStatus
                        )
                    )
                }
                .class("admin-detail-actions")
            }
        }
        .class("cms-section")
    }

    private var actions: [AdminDetailView.Action] {
        var result: [AdminDetailView.Action] = []
        if state.permissions.contains(BlogPermissions.Tags.update.rawValue) {
            result.append(
                .init(
                    label: "Edit tag",
                    href: BlogAdminRoutes.tagEdit(RouterPath(state.rule.id))
                        .description,
                    style: .primary
                )
            )
        }
        if state.permissions.contains(BlogPermissions.Tags.delete.rawValue) {
            result.append(
                .init(
                    label: "Remove tag",
                    href: BlogAdminRoutes.tagRemove(RouterPath(state.rule.id))
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
