//
//  Settings+DTOs.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain

extension Settings {
    var asDetail: SettingsDetail {
        .init(
            postListPath: postListPath,
            authorListPath: authorListPath,
            tagListPath: tagListPath,
            postPathPrefix: postPathPrefix,
            authorPathPrefix: authorPathPrefix,
            tagPathPrefix: tagPathPrefix
        )
    }
}
