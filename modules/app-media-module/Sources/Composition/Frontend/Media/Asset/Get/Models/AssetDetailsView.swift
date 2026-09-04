import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AssetDetailsView: Leaf {
    let item: Components.Schemas.MediaAssetDetailSchema
    let variants: [Components.Schemas.MediaAssetVariantListItemSchema]
    let breadcrumb: AdminBreadcrumb.State
    let canEdit: Bool
    let canRemove: Bool

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

    func renderHTML() -> some BasicTag {
        Section {
            AdminDetailFieldStyleAnchor().renderHTML()
            AdminBreadcrumb(state: breadcrumb).renderHTML()
            H1("Media asset details")
            AdminDetailsField(label: "ID", value: item.id).renderHTML()
            AdminDetailsField(label: "Storage key", value: item.storageKey).renderHTML()
            AdminDetailsField(label: "Type", value: item._type).renderHTML()
            AdminDetailsField(label: "Status", value: item.status).renderHTML()
            AdminDetailsField(label: "Size bytes", value: "\(item.sizeBytes)").renderHTML()
            Div {
                P("Preview original")
                    .class("admin-details-field__label")
                P {
                    A("Preview original")
                        .href(
                            previewLink(for: item.storageKey, isVariant: false)
                        )
                        .target(.blank)
                }
                .class("admin-details-field__value")
            }
            .class("admin-details-field")
            if let title = item.title {
                AdminDetailsField(label: "Title", value: title).renderHTML()
            }
            if let altText = item.altText {
                AdminDetailsField(label: "Alt text", value: altText).renderHTML()
            }
            if variants.isEmpty {
                P("No generated variants linked to this asset yet.")
            }
            else {
                H2("Associated variants")
                ListTableShell(
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
                                        A("Preview")
                                            .href(
                                                previewLink(
                                                    for: variant.storageKey,
                                                    isVariant: true
                                                )
                                            )
                                            .target(.blank)
                                            .class("row-btn")
                                    }
                                }
                            }
                        }
                    }
                    .class("cms-table")
                ).renderHTML()
            }
            Div {
                if canEdit {
                    AdminNavigationButton(
                        "Edit asset",
                        href: "/admin/media/assets/\(item.id)/edit/"
                    ).renderHTML()
                }
                if canRemove {
                    AdminNavigationButton(
                        "Remove asset",
                        href: "/admin/media/assets/\(item.id)/remove/",
                        classes: ["danger"]
                    ).renderHTML()
                }
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
