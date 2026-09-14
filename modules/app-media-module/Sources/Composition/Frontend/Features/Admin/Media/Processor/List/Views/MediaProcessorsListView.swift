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

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            if !permissions.allows(MediaPermissions.Processors.list) {
                context.render(
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
                context.render(
                    NewAdminBreadcrumb(
                        links: MediaProcessorRoutes.listBreadcrumb
                    )
                )
                context.render(
                    NewAdminPageHeader(
                        state: .init(
                            title: "Media processors",
                            description:
                                "Manage automated media processing rules."
                        )
                    )
                )
                context.render(
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
