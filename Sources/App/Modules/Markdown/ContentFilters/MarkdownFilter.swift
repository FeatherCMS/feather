//
//  MarkdownFilter.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 18..
//

import Vapor
import Fluent
import ViperKit
import Ink

struct MarkdownFilter: ContentFilter {
    var key: String { "markdown-ink" }
    var label: String { "Markdown (Ink)" }

    func filter(_ input: String) -> String {
        "<section>" + MarkdownParser().html(from: input.replacingOccurrences(of: "\r", with: "\n")) + "</section>"
    }
}
