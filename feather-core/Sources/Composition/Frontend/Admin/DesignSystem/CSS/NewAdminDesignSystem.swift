//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import CSS
import WebBuilders

public struct NewAdminDesignSystem {

    public init() {}

    @Builder<CSS.Rule>
    public func rules() -> [any Rule] {
        variables()
        base()
        layouts()
        topbar()
        navigation()
        breadcrumb()
    }
}
