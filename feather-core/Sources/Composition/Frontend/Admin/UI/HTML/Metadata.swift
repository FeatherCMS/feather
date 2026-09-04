//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 01..
//

import CSS
import HTML
import SGML
import WebComponents
import WebBuilders

public struct Metadata: Leaf {

    let canonicalUrl: String
    let title: String
    let description: String
    let imageUrl: String?
    let noIndex: Bool

    public init(
        canonicalUrl: String,
        title: String,
        description: String,
        imageUrl: String?,
        noIndex: Bool
    ) {
        self.canonicalUrl = canonicalUrl
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.noIndex = noIndex
    }

    public func renderHTML() -> Head {
        Head {
            Meta().charset("utf-8")
            Meta().name(.viewport).content("width=device-width, initial-scale=1")
            Link(rel: .canonical).href(canonicalUrl)

            Title(title)
            Meta().name(.description).content(description)
            if noIndex {
                Meta().name("robots").content("noindex")
            }

            Meta().property("og:url").content(canonicalUrl)
            Meta().property("og:title").content(title)
            Meta().property("og:description").content(description)
            if let imageUrl {
                Meta().property("og:image").content(imageUrl)
            }

            Meta().name("twitter:card").content("summary_large_image")
            Meta().name("twitter:url").content(canonicalUrl)
            Meta().name("twitter:title").content(title)
            Meta().name("twitter:description").content(description)
            if let imageUrl {
                Meta().name("twitter:image").content(imageUrl)
            }
        }
    }
}
