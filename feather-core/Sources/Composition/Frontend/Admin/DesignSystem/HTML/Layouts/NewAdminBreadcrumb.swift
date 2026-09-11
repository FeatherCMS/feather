//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminBreadcrumb: Component {

    public struct State: Sendable {
        public let links: [Link]

        public init(links: [Link]) {
            self.links = links
        }
    }

    public struct Link: Sendable {
        public let label: String
        public let link: String

        public init(label: String, link: String) {
            self.label = label
            self.link = link
        }
    }

    public let links: [Link]

    public init(state: State) {
        self.links = state.links
    }

    public init(links: [Link]) {
        self.links = links
    }

    public func html(context: inout RenderContext) -> Nav {
        Nav {
            if !links.isEmpty {
                Ol {
                    for breadcrumb in links {
                        Li { A(breadcrumb.label).href(breadcrumb.link) }
                    }
                }
            }
        }
        .class("breadcrumb")
        .ariaLabel("Breadcrumb")
    }
}
