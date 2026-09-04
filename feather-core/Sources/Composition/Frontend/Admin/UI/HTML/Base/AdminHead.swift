//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 08..
//

import CSS
import HTML
import SGML
import SVG
import WebComponents
import WebBuilders

public struct AdminHeadElements: Leaf {

    struct State {
        let canonicalUrl: String
        let title: String
        let description: String
        let imageUrl: String
        let externalCSSUrls: [String]
        let css: String
    }

    let state: State

    public func html() -> Head {
        let metadata = Metadata(
            canonicalUrl: state.canonicalUrl,
            title: state.title,
            description: state.description,
            imageUrl: state.imageUrl,
            noIndex: false
        ).html()

        return Head(elements: metadata.children.compactMap { $0 as? any MetadataContent } + state.externalCSSUrls.map {
            Link(rel: .stylesheet).href($0)
        } + [Style(state.css)])
    }
}
