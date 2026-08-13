//
//  WebRouteDetail.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts

public struct WebRouteDetail: DTO {
    public let referenceType: String
    public let referenceID: String
    public let slug: String
    public let template: String

    public init(
        referenceType: String,
        referenceID: String,
        slug: String,
        template: String
    ) {
        self.referenceType = referenceType
        self.referenceID = referenceID
        self.slug = slug
        self.template = template
    }
}
