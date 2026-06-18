import HTML
import SGML
import WebStandards

struct AssetRemoveView: Component {
    let id: String
    let breadcrumb: AdminBreadcrumb.State

    func content() -> some BasicTag {
        AdminConfirmationDialog(
            state: .init(
                breadcrumb: breadcrumb,
                title: "Remove media asset",
                message:
                    "Are you sure you want to remove this asset? This action cannot be undone.",
                details: [
                    .init(prefix: "ID: ", value: id)
                ],
                submitLabel: "Remove asset",
                actionURL: "/admin/media/assets/\(id)/remove/",
                cancelURL: "/admin/media/assets/"
            )
        )
    }
}
