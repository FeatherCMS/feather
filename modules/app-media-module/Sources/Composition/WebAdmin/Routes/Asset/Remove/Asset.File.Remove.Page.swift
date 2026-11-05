import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.Remove {
    struct Page: Component {
        let item: AdminRemoveItemContext
        let nonceToken: String
        let routes: Asset.Router.Routes

        func html(context: inout BuilderContext) -> some BasicTag {
            context.build(
                AdminRemoveConfirmation(
                    header: .primary(
                        title: "Remove media item",
                        description: "Confirm removal of this media item."
                    ),
                    selectedItems: [item.label],
                    action: routes.file.removePath(item.id),
                    submit: .init(label: "Remove item", style: .destructive),
                    nonceToken: nonceToken,
                    hiddenFields: [.init(name: "ids", value: item.id)]
                )
            )
        }
    }
}
