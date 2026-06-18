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

struct AdminGetUserHomeComponent: Component {

    func content() -> some BasicTag {
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
