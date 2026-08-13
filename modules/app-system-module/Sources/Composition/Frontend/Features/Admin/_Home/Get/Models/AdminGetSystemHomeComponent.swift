import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebStandards

//
//  File.swift
//  web-app
//
//  Addd by Tibor Bödecs on 2026. 03. 08..
//

struct AdminGetSystemHomeComponent: Component {

    func content() -> some BasicTag {
        Section {
            Nav {
                Ol {
                    Li { A("Admin").href("/admin/") }
                    Li("System").ariaCurrent(.page)
                }
            }
            .class("cms-breadcrumb")
            .ariaLabel("Breadcrumb")

            H1("System module")
        }
        .class("cms-section")
    }
}
