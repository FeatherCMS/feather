import FeatherAdmin
import FeatherContracts
import HTML
import MediaAdminAPI
import MediaContracts
import SGML
import WebBuilders
import WebComponents

struct MediaProcessorsListView: Component {
    let items: [Components.Schemas.MediaProcessorListItemSchema]
    let pageState: NewAdminListPageState
    let search: String?
    let permissions: NewAdminListActions

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            if !permissions.allows(MediaPermissions.Processors.list) {
                context.build(
                    NewAdminStatusView(
                        state: .init(
                            title: "Forbidden",
                            message:
                                "Your account cannot access media processors."
                        ),
                        icon: FeatherIcons.lock()
                    )
                )
            }
            else {
                context.build(
                    NewAdminBreadcrumb(
                        links: MediaProcessorRoutes.listBreadcrumb
                    )
                )
                context.build(
                    NewAdminPageHeader(
                        state: .init(
                            title: "Media processors",
                            description:
                                "Manage automated media processing rules."
                        )
                    )
                )
                context.build(
                    MediaProcessorTableContent(
                        items: items,
                        permissions: permissions,
                        pageState: pageState,
                        search: search
                    )
                )
            }
        }
        .class("cms-section")
    }
}
