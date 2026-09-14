import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AssetDetailsView: Component {
    let item: Components.Schemas.MediaAssetDetailSchema
    let variants: [Components.Schemas.MediaAssetVariantListItemSchema]
    let permissions: NewAdminListActions

    private func compactStorageKey(
        _ key: String
    ) -> String {
        let prefix = "media/assets/"
        guard key.hasPrefix(prefix) else { return key }
        return String(key.dropFirst(prefix.count))
    }

    private func previewLink(
        for storageKey: String,
        isVariant: Bool
    ) -> String {
        let normalizedKey = compactStorageKey(storageKey)
        let allowed = CharacterSet(
            charactersIn:
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~/"
        )
        let encoded =
            normalizedKey.addingPercentEncoding(withAllowedCharacters: allowed)
            ?? normalizedKey
        let prefix = isVariant ? "/media/variants/" : "/media/assets/"
        return
            "\(AppEnvironmentStore.current.publicOrigins.mediaBaseURL.absoluteString)\(prefix)\(encoded)"
    }

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(
                NewAdminBreadcrumb(links: MediaAssetRoutes.breadcrumb)
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Media asset details",
                        description:
                            "Review asset metadata and generated variants."
                    )
                )
            )
            context.render(
                NewAdminDetailField(label: "ID", value: item.id)
            )
            context.render(
                NewAdminDetailField(
                    label: "Storage key",
                    value: item.storageKey
                )
            )
            context.render(
                NewAdminDetailField(label: "Type", value: item._type)
            )
            context.render(
                NewAdminDetailField(label: "Status", value: item.status)
            )
            context.render(
                NewAdminDetailField(
                    label: "Size bytes",
                    value: "\(item.sizeBytes)"
                )
            )
            if let title = item.title {
                context.render(
                    NewAdminDetailField(label: "Title", value: title)
                )
            }
            if let altText = item.altText {
                context.render(
                    NewAdminDetailField(label: "Alt text", value: altText)
                )
            }
            context.render(
                NewAdminButton(
                    "Open original",
                    href: previewLink(for: item.storageKey, isVariant: false),
                    style: .secondary
                )
            )
            if variants.isEmpty {
                P("No generated variants linked to this asset yet.")
            }
            else {
                H2("Associated variants")
                context.render(
                    NewAdminListShell(
                        layout: .init(
                            name: "media-asset-variants",
                            columns: [
                                .fraction(1),
                                .fixed(100),
                                .fraction(2),
                                .fixed(120),
                            ]
                        ),
                        hasSelection: false,
                        table: Table {
                            Thead {
                                Tr {
                                    Th("Name")
                                    Th("Type")
                                    Th("Storage key")
                                    Th("Preview")
                                }
                            }
                            Tbody {
                                for variant in variants {
                                    Tr {
                                        Td(variant.name)
                                        Td(variant._type)
                                        Td(variant.storageKey)
                                        Td {
                                            context.render(
                                                NewAdminRowButton(
                                                    "Preview",
                                                    href: previewLink(
                                                        for: variant.storageKey,
                                                        isVariant: true
                                                    ),
                                                    style: .ghost(.primary)
                                                )
                                            )
                                        }
                                        .data("label", "Preview")
                                    }
                                }
                            }
                        }
                        .class("cms-table")
                    )
                )
            }
            Div {
                if permissions.allows(MediaPermissions.Assets.update) {
                    context.render(
                        NewAdminButton(
                            "Edit",
                            href:
                                MediaAssetRoutes.edit(
                                    RouterPath(item.id)
                                )
                                .description
                        )
                    )
                }
                if permissions.allows(MediaPermissions.Assets.delete) {
                    context.render(
                        NewAdminButton(
                            "Remove",
                            href:
                                MediaAssetRoutes.remove(
                                    RouterPath(item.id)
                                )
                                .description,
                            style: .destructive
                        )
                    )
                }
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
