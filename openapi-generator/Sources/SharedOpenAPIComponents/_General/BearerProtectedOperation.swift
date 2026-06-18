//
//  OpenAPI+Security.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 02. 05..
//

import FeatherOpenAPI
import OpenAPIKit30

public protocol BearerProtectedOperation: OperationRepresentable {}

extension BearerProtectedOperation {

    public var security: [SecurityRequirementRepresentable]? {
        [
            BearerSecurityRequirement()
        ]
    }

    private var responseMapWithAuthFailures: ResponseMap {
        var result = responseMap
        result[401] = CustomResponse.unauthorized
        result[403] = CustomResponse.forbidden
        return result
    }

    public func openAPIOperation() -> OpenAPI.Operation {
        let openAPITags = tags.isEmpty ? nil : tags.map(\.name)
        let openAPISecurity: [OpenAPI.SecurityRequirement]? = [
            BearerSecurityRequirement().openAPISecurityRequirement()
        ]
        let responses = responseMapWithAuthFailures.mapValues {
            $0.openAPIResponse()
        }

        if let requestBody {
            return .init(
                tags: openAPITags,
                summary: summary,
                description: description,
                externalDocs: nil,
                operationId: operationId,
                parameters: parameters.map { $0.openAPIParameter() },
                requestBody: requestBody.openAPIRequestBody(),
                responses: responses,
                callbacks: [:],
                deprecated: deprecated,
                security: openAPISecurity,
                servers: servers?.map { $0.openAPIServer() },
                vendorExtensions: vendorExtensions
            )
        }
        return .init(
            tags: openAPITags,
            summary: summary,
            description: description,
            externalDocs: nil,
            operationId: operationId,
            parameters: parameters.map { $0.openAPIParameter() },
            responses: responses,
            callbacks: [:],
            deprecated: deprecated,
            security: openAPISecurity,
            servers: servers?.map { $0.openAPIServer() },
            vendorExtensions: vendorExtensions
        )
    }
}

public struct BearerSecurityRequirement: SecurityRequirementRepresentable {
    public var security: any SecuritySchemeRepresentable =
        BearerSecurityScheme()

    public init() {}
}

public struct BearerSecurityScheme: SecuritySchemeRepresentable {

    public var openAPIIdentifier: String { "bearerAuth" }

    public var type: OpenAPIKit30.OpenAPI.SecurityScheme.SecurityType = .http(
        scheme: "bearer",
        bearerFormat: nil
    )

    public init() {}
}
