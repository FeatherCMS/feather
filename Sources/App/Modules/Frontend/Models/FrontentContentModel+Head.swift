//
//  FrontendContentModel+Head.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 18..
//

import Vapor

extension FrontendContentModel {
    var headContext: HeadContext {
        .init(title: self.title,
              excerpt: self.excerpt,
              imageKey: self.imageKey,
              canonicalUrl: self.canonicalUrl,
              indexed: self.status == .published)
    }
}
