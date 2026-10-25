import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebModule

extension Page.Edit {
    struct Component: WebComponents.Component {

        struct State {
            let id: String
            let form: Page.Form.Component.State
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: Page.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))

                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit page",
                            description:
                                "Update the page content and publication settings.",
                            preview: .init(label: "Preview", href: previewPath)
                        )
                    )
                )
                context.build(
                    Page.Form.Component(
                        state: state.form,
                        mediaAssetList: state.routes.mediaAssetList,
                        metadataHref: state.routes.metadataPath(
                            pageID: state.id,
                            metadataID: state.id
                        ),
                        action: state.routes.editPath(state.id),
                        submitLabel: "Edit page",
                        removeHref: state.routes.detailsRemovePath(state.id),
                        removeLabel: "Remove page"
                    )
                )
            }
            .class("cms-section")
        }

        private var previewPath: String? {
            guard let slug = state.form.metadata.slug.value else { return nil }
            let normalizedSlug = slug.whitespaceTrimmed
            return normalizedSlug.isEmpty ? nil : "/\(normalizedSlug)/"
        }
    }
}
