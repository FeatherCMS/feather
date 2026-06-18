//
//  File.swift
//  web-app
//
//  Addd by Tibor Bödecs on 2026. 03. 08..
//

import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminGetBlogHomeComponent: Component {

    func content() -> some BasicTag {
        Section {
            Nav {
                Ol {
                    Li { A("Admin").href("/admin/") }
                    Li("Blog").ariaCurrent(.page)
                }
            }
            .class("cms-breadcrumb")
            .ariaLabel("Breadcrumb")

            H1("Blog module")
            Ul {
                Li { A("Posts").href("/admin/blog/posts/") }
                Li { A("Authors").href("/admin/blog/authors/") }
                Li { A("Tags").href("/admin/blog/tags/") }
                Li { A("Settings").href("/admin/blog/settings/") }
            }
        }
        .class("cms-section")
    }
}
