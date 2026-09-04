import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

//
//  File.swift
//  web-app
//
//  Addd by Tibor Bödecs on 2026. 03. 08..
//

struct AdminGetWebHomeComponent: Leaf {

    func renderHTML() -> some BasicTag {
        Section {
            Nav {
                Ol {
                    Li { A("Admin").href("/admin/") }
                    Li("Web").ariaCurrent(.page)
                }
            }
            .class("cms-breadcrumb")
            .ariaLabel("Breadcrumb")

            H1("Web module")
            Ul {
                Li { A("Pages").href("/admin/web/pages/") }
                Li { A("Menus").href("/admin/web/menus/") }
                Li { A("Metadata").href("/admin/web/metadata/") }
                Li { A("Settings").href("/admin/web/settings/") }
            }
        }
        .class("cms-section")
    }
}
