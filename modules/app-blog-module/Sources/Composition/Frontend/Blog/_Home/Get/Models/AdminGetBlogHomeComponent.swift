import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

//
//  File.swift
//  web-app
//
//  Addd by Tibor Bödecs on 2026. 03. 08..
//

struct AdminGetBlogHomeComponent: Leaf {

    func renderHTML() -> some BasicTag {
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
