import FeatherAdmin
import FeatherContracts
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebContracts

struct WebPageDetails: Component {
    struct State {
        let rule: WebPageDetailsModel
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let permissions: Set<String>
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Web page details",
                        description: "Review the page content and publication state."
                    )
                )
            )
            Div {
                detailField(label: "ID", value: state.rule.id)
                detailField(label: "Title", value: state.rule.title)
                detailField(label: "Status", value: state.rule.metadata.status.capitalized)
                detailField(
                    label: "Published date",
                    value: format(state.rule.metadata.publicationDate)
                )
                detailField(
                    label: "Expiration date",
                    value: format(state.rule.metadata.expirationDate)
                )
            }
            .class("admin-detail-view-fields")
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
                    WebPermissions.Pages.update.rawValue
                ) {
                    context.render(
                        NewAdminStatusActionForm(
                            action: "/admin/web/pages/\(state.rule.id)/status/",
                            returnTo: "/admin/web/pages/\(state.rule.id)/",
                            status: isPublished ? "draft" : "published",
                            label: isPublished ? "Unpublish" : "Publish",
                            classes: ["secondary"]
                        )
                    )
                    context.render(
                        NewAdminButton(
                            "Edit page",
                            href: WebPageRoutes.edit(RouterPath(state.rule.id)).description
                        )
                    )
                }
                if state.permissions.contains(
                    WebPermissions.Pages.delete.rawValue
                ) {
                    context.render(
                        NewAdminButton(
                            "Remove page",
                            href: WebPageRoutes.details(RouterPath(state.rule.id)).appendingPath(RouterPath("remove")).description,
                            style: .destructive
                        )
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

    private func detailField(label: String, value: String) -> Div {
        Div {
            P(label).class("admin-detail-view-field-label")
            P(value).class("admin-detail-view-field-value")
        }
        .class("admin-detail-view-field")
    }
}
