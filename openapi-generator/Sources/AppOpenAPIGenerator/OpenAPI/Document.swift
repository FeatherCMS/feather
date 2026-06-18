//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 10..
//

import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

struct Info: InfoRepresentable {
    var title: String { "App API" }
    var version: String { "0.1.0" }
}

struct TestServer: ServerRepresentable {

    var url: any LocationRepresentable {
        Location("http://127.0.0.1:8080/")
    }
}

struct Document: DocumentRepresentable {

    var info: OpenAPIInfoRepresentable

    var servers: [any OpenAPIServerRepresentable] {
        [
            TestServer()
        ]
    }

    var paths: PathMap
    var components: OpenAPIComponentsRepresentable

    init() {
        let collection = PathCollection()

        self.info = Info()
        self.paths = collection.pathMap
        self.components = collection.components
    }
}
