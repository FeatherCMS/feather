import FeatherWebAdmin
import HTML
import MediaAdminAPI
import MediaModule
import WebBuilders
import WebComponents

extension Variant.Processor.List {
    struct Row: Component {
        let variantId: String
        let processor:
            MediaAdminAPI.Components.Schemas
                .MediaVariantProcessorQueryItemSchema
        let permissions: AdminListActions
        let returnTo: String
        let routes: Variant.Router.Routes

        func html(context: inout BuilderContext) -> Tr {
            Tr {
                if permissions.allows(Variant.Processor.Permissions.delete) {
                    context.build(AdminListRowCheckbox(id: processor.id))
                }
                Td(processor.name).data("label", "Name")
                Td(processor.matchExtensions).data("label", "Input extensions")
                Td(processor.commandTemplate).data("label", "Command template")
                Td(processor.isActive ? "Yes" : "No").data("label", "Active")
                context.build(
                    AdminListRowActions(
                        label: "Actions",
                        actions: [
                            .init(
                                "Edit",
                                href: routes.processorEditPath(
                                    variantId,
                                    processorId: processor.id
                                ),
                                style: .ghost(.primary),
                                permission: Variant.Processor.Permissions.update
                            )
                        ],
                        permissions: permissions
                    )
                )
            }
        }
    }
}
