import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

//
//  File.swift
//  web-app
//
//  Addd by Tibor Bödecs on 2026. 03. 08..
//

struct AdminViewWebOverviewComponent: Component {

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: WebAdminRoutes.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Web module",
                        description: "Manage pages, menus, metadata, and web settings."
                    )
                )
            )
            Ul {
                Li { A("Pages").href(WebPageRoutes.list.description) }
                Li { A("Menus").href(WebMenuRoutes.list.description) }
                Li { A("Metadata").href(WebMetadataRoutes.list.description) }
                Li { A("Settings").href(WebSettingsRoutes.edit.description) }
            }
        }
        .class("cms-section")
    }
}
