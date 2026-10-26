//
//  OpenAPI+Security.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 02. 05..
//

public import FeatherOpenAPI
public import OpenAPIKit30

public protocol BearerProtectedOperation: OperationRepresentable {}

extension BearerProtectedOperation {

    public var security: [any SecurityRequirementRepresentable]? {
        [
            BearerSecurityRequirement()
        ]
    }

    private var responseMapWithAuthFailures: ResponseMap {
        var result = responseMap
        result[401] = DefaultHTTPErrorContentResponse(
            description: "Unauthorized"
        )
        result[403] = DefaultHTTPErrorContentResponse(
            description: "Forbidden"
        )
        return result
    }

    public var referencedSchemaMap:
        OrderedDictionary<SchemaID, any OpenAPISchemaRepresentable>
    {
        var result = OrderedDictionary<
            SchemaID, any OpenAPISchemaRepresentable
        >()

        for parameter in parameters {
            result.merge(parameter.referencedSchemaMap) { _, new in new }
        }

        if let requestBody {
            result.merge(requestBody.referencedSchemaMap) { _, new in new }
        }

        for response in responseMapWithAuthFailures.values {
            for content in response.contentMap.values {
                result.merge(content.referencedSchemaMap) { _, new in new }
            }
        }

        return result
    }

    public func openAPIOperation() -> OpenAPI.Operation {
        openAPIOperation(
            responseMap: responseMapWithAuthFailures,
            security: [BearerSecurityRequirement()]
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

    public var type: OpenAPI.SecurityScheme.SecurityType = .http(
        scheme: "bearer",
        bearerFormat: nil
    )

    public init() {}
}
