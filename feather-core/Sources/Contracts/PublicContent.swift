//
//  Metadata.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 23..
//

public enum PublicContent {

    public enum Metadata {
        public struct Base: Codable, Hashable, Sendable {
            public let referenceType: String
            public let referenceId: String
            public let slug: String
            public let template: String?

            public init(
                referenceType: String,
                referenceId: String,
                slug: String,
                template: String?
            ) {
                self.referenceType = referenceType
                self.referenceId = referenceId
                self.slug = slug
                self.template = template
            }
        }
    }
}
