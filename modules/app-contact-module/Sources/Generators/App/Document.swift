//
//  Document.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 10..
//

import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct Document: DocumentRepresentable {

    var info: any OpenAPIInfoRepresentable

    var servers: [any OpenAPIServerRepresentable] {
        [
            TestServer()
        ]
    }

    var paths: PathMap
    var components: any OpenAPIComponentsRepresentable

    init() {
        let collection = PathCollection()

        self.info = Info()
        self.paths = collection.pathMap
        self.components = collection.components
    }
}
