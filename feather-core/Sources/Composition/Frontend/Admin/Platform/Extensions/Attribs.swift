//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 01..
//

import HTML

extension Img {

    func size(
        _ value: Int
    ) -> Self {
        width(value).height(value)
    }
}
