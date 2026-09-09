//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import HTML
import CSS
import SGML
import WebComponents
import WebBuilders

public struct NewAdminBreadcrumb: Leaf {

    public struct Link: Sendable {
        public let label: String
        public let link: String

        public init(label: String, link: String) {
            self.label = label
            self.link = link
        }
    }

    public let links: [Link]

    public init(links: [Link]) {
        self.links = links
    }

    public func selectors() -> [any Selector] {
        Class("breadcrumb") {

        }
        Custom("breadcrumb li") {

        }
    }

    public func html() -> Nav {
        Nav {
            Ol {
                for (idx, breadcrumb) in links.enumerated() {
                    if idx == links.count - 1 {
                        Li(breadcrumb.label).ariaCurrent(.page)
                    }
                    else {
                        Li { A(breadcrumb.label).href(breadcrumb.link) }
                    }
                }
            }
        }
        .class("breadcrumb")
        .ariaLabel("Breadcrumb")
    }
}
