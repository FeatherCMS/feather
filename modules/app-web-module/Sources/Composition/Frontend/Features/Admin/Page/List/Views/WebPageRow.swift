import FeatherAdmin
import FeatherContracts
import Foundation
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents
import WebContracts

struct WebPageRow: Component {
    let page: AdminListWebPageItemModel
    let permissions: NewAdminListActions
    let canEdit: Bool
    let returnTo: String

    func html(context: inout RenderContext) -> Tr {
        Tr {
            if permissions.allows(WebPermissions.Pages.delete) {
                context.render(NewAdminListRowCheckbox(id: page.id))
            }
            titleCell()
            statusCell(context: &context)
            Td(format(page.metadata.publicationDate))
                .data("label", "Publication")
            Td(format(page.metadata.expirationDate)).data("label", "Expiration")
            context.render(
                NewAdminListRowActions(
                    label: "Actions",
                    actions: [
                        .init(
                            "View",
                            href: WebPageRoutes.details(RouterPath(page.id))
                                .description,
                            style: .ghost(.primary),
                            permission: WebPermissions.Pages.read
                        ),
                        .init(
                            "Edit",
                            href: WebPageRoutes.edit(RouterPath(page.id))
                                .description,
                            style: .ghost(.secondary),
                            permission: WebPermissions.Pages.update
                        ),
                        .init(
                            "Remove",
                            href: NewAdminLocation.remove(
                                path: WebPageRoutes.remove.description,
                                ids: [page.id],
                                returnTo: returnTo
                            ),
                            style: .destructive,
                            permission: WebPermissions.Pages.delete
                        ),
                    ],
                    permissions: permissions
                )
            )
        }
    }

    private func titleCell() -> Td {
        Td {
            Span {
                Span(page.title)
                if let previewPath = previewPath {
                    A { FeatherIcons.externalLink() }
                        .href(previewPath)
                        .target(.blank)
                        .ariaLabel("Preview \(page.title)")
                }
            }
        }
        .data("label", "Title")
    }

    private func statusCell(context: inout RenderContext) -> Td {
        Td {
            if canEdit {
                context.render(
                    NewAdminStatusSelectField(
                        formID: "web-page-status-\(page.id)",
                        selectedStatus: page.metadata.normalizedStatus
                    )
                )
            }
            else {
                Span(page.metadata.status.capitalized)
            }
        }
        .data("label", "Status")
    }

    private var previewPath: String? {
        let slug = page.metadata.normalizedSlug
        return slug.isEmpty ? nil : "/\(slug)/"
    }

    private func format(_ value: String) -> String {
        guard let timestamp = AdminMetadataSchemaBuilder.parseTimestamp(value)
        else { return "-" }
        return DateFormatting.formatUnixTimestamp(timestamp)
    }
}
