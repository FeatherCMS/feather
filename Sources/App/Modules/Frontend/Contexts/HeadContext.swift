//
//  HeadContext.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 18..
//

import Vapor

struct HeadContext: Encodable {
    var title: String?
    var excerpt: String?
    var imageKey: String? = nil
    var canonicalUrl: String? = nil
    var indexed: Bool = true
}

