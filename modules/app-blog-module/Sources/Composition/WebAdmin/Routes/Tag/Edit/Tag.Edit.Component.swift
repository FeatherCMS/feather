import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents

import protocol SGML.BasicTag

extension Tag.Edit {
    struct Component: WebComponents.Component {
        struct State {
            let id: String
            let form: Tag.Form.State
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: Tag.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit tag",
                            description: "Update this blog tag.",
                            moreActions: [
                                .init(
                                    label: "Remove tag",
                                    href: state.routes.tagRemovePath(state.id),
                                    style: .destructive
                                )
                            ]
                        )
                    )
                )
                context.build(
                    Tag.Form(
                        state: state.form,
                        browsePath: state.routes.imagePickerPath(
                            state.form.imageAssetId.key
                        ),
                        metadataHref: state.routes
                            .tagEditMetadataPath(
                                state.id,
                                state.id
                            ),
                        action: state.routes.tagEditPath(state.id),
                        submitLabel: "Edit tag",
                    )
                )
            }
            .class("cms-section")
        }
    }
}
