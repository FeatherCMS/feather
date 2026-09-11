import FeatherAdmin
import FeatherContracts
import Foundation
import HTML
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebContracts

struct WebPageDetails: Component {
    struct State {
        let rule: WebPageDetailsModel
        let breadcrumb: AdminBreadcrumb.State
        let permissions: Set<String>
        let isPublished: Bool
        let isUnpublished: Bool
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("Web page details")
            if state.isPublished {
                P("Web page published successfully.")
            }
            if state.isUnpublished {
                P("Web page unpublished successfully.")
            }
            context.render(AdminDetailsField(label: "ID", value: state.rule.id))
            context.render(
                AdminDetailsField(label: "Title", value: state.rule.title)
            )
            context.render(
                AdminDetailsField(
                    label: "Status",
                    value: state.rule.metadata.status.capitalized
                )
            )
            context.render(
                AdminDetailsField(
                    label: "Published date",
                    value: format(state.rule.metadata.publicationDate)
                )
            )
            context.render(
                AdminDetailsField(
                    label: "Expiration date",
                    value: format(state.rule.metadata.expirationDate)
                )
            )
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
                        AdminStatusActionForm(
                            action: "/admin/web/pages/\(state.rule.id)/status/",
                            returnTo: "/admin/web/pages/\(state.rule.id)/",
                            status: isPublished ? "draft" : "published",
                            label: isPublished ? "Unpublish" : "Publish",
                            classes: ["secondary"]
                        )
                    )
                    context.render(
                        AdminNavigationButton(
                            "Edit page",
                            href: "/admin/web/pages/\(state.rule.id)/edit/"
                        )
                    )
                }
                if state.permissions.contains(
                    WebPermissions.Pages.delete.rawValue
                ) {
                    context.render(
                        AdminNavigationButton(
                            "Remove page",
                            href: "/admin/web/pages/\(state.rule.id)/remove/",
                            classes: ["danger"]
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
}
