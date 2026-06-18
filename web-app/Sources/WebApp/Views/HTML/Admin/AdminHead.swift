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
import WebStandards

struct AdminHeadElements: Component, MetadataContent {

    struct State {
        let canonicalUrl: String
        let title: String
        let description: String
        let imageUrl: String
        let externalCSSUrls: [String]
        let css: String
    }

    let state: State

    func content() -> some BasicTag {
        Metadata(
            canonicalUrl: state.canonicalUrl,
            title: state.title,
            description: state.description,
            imageUrl: state.imageUrl,
            noIndex: false
        )

        for externalCSSUrl in state.externalCSSUrls {
            Link(rel: .stylesheet).href(externalCSSUrl)
        }
        Style(state.css)
    }
}
