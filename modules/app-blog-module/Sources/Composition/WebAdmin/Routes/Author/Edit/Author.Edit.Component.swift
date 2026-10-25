import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents

import protocol SGML.BasicTag

extension Author.Edit {
    struct Component: WebComponents.Component {
        struct State {
            let id: String
            let form: Author.Form.State
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: Author.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit author",
                            description: "Update this blog author.",
                            actions: [
                                .init(
                                    label: "Remove author",
                                    href: state.routes.authorRemovePath(
                                        state.id
                                    ),
                                    style: .destructive
                                )
                            ]
                        )
                    )
                )
                context.build(
                    Author.Form(
                        state: state.form,
                        browsePath: state.routes.imagePickerPath(
                            state.form.profileImageAssetId.key
                        ),
                        metadataHref: state.routes
                            .authorEditMetadataPath(
                                state.id,
                                state.id
                            ),
                        action: state.routes.authorEditPath(state.id),
                        submitLabel: "Edit author",
                        removeHref: nil
                    )
                )
            }
            .class("cms-section")
        }
    }
}
