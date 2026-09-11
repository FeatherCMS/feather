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

struct AdminGetUserHomeComponent: Component {

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            Nav {
                Ol {
                    Li { A("Admin").href("/admin/") }
                    Li("User").ariaCurrent(.page)
                }
            }
            .class("cms-breadcrumb")
            .ariaLabel("Breadcrumb")

            H1("User module")

        }
        .class("cms-section")
    }
}
