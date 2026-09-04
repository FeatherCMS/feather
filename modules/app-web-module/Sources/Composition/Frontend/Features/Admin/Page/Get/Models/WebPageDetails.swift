import FeatherAdmin
import FeatherContracts
import Foundation
import HTML
import OpenAPIRuntime
import SGML
import WebContracts
import WebComponents
import WebBuilders

struct WebPageDetails: Leaf {
    struct State {
        let rule: WebPageDetailsModel
        let breadcrumb: AdminBreadcrumb.State
        let permissions: Set<String>
        let isPublished: Bool
        let isUnpublished: Bool
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1("Web page details")
            if state.isPublished {
                P("Web page published successfully.")
            }
            if state.isUnpublished {
                P("Web page unpublished successfully.")
            }
            AdminDetailsField(label: "ID", value: state.rule.id).html()
            AdminDetailsField(label: "Title", value: state.rule.title).html()
            AdminDetailsField(
                label: "Status",
                value: state.rule.metadata.status.capitalized
            ).html()
            AdminDetailsField(
                label: "Published date",
                value: format(state.rule.metadata.publicationDate)
            ).html()
            AdminDetailsField(
                label: "Expiration date",
                value: format(state.rule.metadata.expirationDate)
            ).html()
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
                    AdminStatusActionForm(
                        action: "/admin/web/pages/\(state.rule.id)/status/",
                        returnTo: "/admin/web/pages/\(state.rule.id)/",
                        status: isPublished ? "draft" : "published",
                        label: isPublished ? "Unpublish" : "Publish",
                        classes: ["secondary"]
                    ).html()
                    AdminNavigationButton(
                        "Edit page",
                        href: "/admin/web/pages/\(state.rule.id)/edit/"
                    ).html()
                }
                if state.permissions.contains(
                    WebPermissions.Pages.delete.rawValue
                ) {
                    AdminNavigationButton(
                        "Remove page",
                        href: "/admin/web/pages/\(state.rule.id)/remove/",
                        classes: ["danger"]
                    ).html()
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
