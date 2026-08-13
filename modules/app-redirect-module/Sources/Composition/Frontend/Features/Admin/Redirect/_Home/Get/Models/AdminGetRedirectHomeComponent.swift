import FeatherAdmin
import Foundation
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

struct AdminGetRedirectHomeComponent: Component {

    func content() -> some BasicTag {
        Section {
            Nav {
                Ol {
                    Li { A("Admin").href("/admin/") }
                    Li("Redirect").ariaCurrent(.page)
                }
            }
            .class("cms-breadcrumb")
            .ariaLabel("Breadcrumb")

            H1("Redirect module")
        }
        .class("cms-section")
    }
}
