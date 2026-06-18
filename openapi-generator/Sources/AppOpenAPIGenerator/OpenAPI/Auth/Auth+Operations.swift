//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 23..
//

import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

struct AuthRegisterOperation: OperationRepresentable {
    var tags: [TagRepresentable] { [AuthTag()] }

    var requestBody: RequestBodyRepresentable? {
        AuthRegisterRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: AuthMeResponse().reference()
        ]
    }
}
