import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMetadataEdit: Component {

    struct State {
        let id: String
        let form: WebMetadataForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let action: String
        let navigationTabs: [NewAdminPillTab.Link]
        let title: String
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: state.title,
                        description: "Edit the metadata used when this page is rendered and shared.",
                        previewHref: previewPath
                    )
                )
            )
            context.render(NewAdminPillTab(links: state.navigationTabs))
            context.render(
                WebMetadataForm(
                    state: state.form,
                    action: state.action,
                    submitLabel: "Edit entry"
                )
            )
        }
        .class("cms-section")
    }

    private var previewPath: String? {
        guard let slug = state.form.slug.value else { return nil }
        let normalizedSlug = slug.trimmingCharacters(in: .whitespacesAndNewlines)
        return normalizedSlug.isEmpty ? nil : "/\(normalizedSlug)/"
    }
}
