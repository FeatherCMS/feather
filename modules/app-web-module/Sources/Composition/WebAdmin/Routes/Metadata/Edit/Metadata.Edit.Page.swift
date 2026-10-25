import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebModule

extension WebModule.Metadata.Edit {
    struct Page: Component {
        struct State {
            let id: String
            let form: Form.Component.State
            let mediaAssetList: WebRoute
            let breadcrumb: [AdminBreadcrumb.Link]
            let action: String
            let navigationTabs: [AdminTabBar.Link]
            let pageHeader: AdminPageHeader.State
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(state: state.pageHeader)
                )
                context.build(AdminTabBar(links: state.navigationTabs))
                context.build(
                    Form.Component(
                        state: state.form,
                        mediaAssetList: state.mediaAssetList,
                        action: state.action,
                        submitLabel: "Edit entry"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
