import FeatherApplication
import FeatherContracts
import FeatherDomain
import WebContracts
import WebDomain

//
//  GetPage.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct GetPage: UseCase {
    struct Action: PermissionAction {
        let key = WebPermissions.Pages.read
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadPageMetadata>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadPageMetadata>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let id: String

        public init(
            id: String
        ) {
            self.id = id
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> PageDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let id = input.id

        return try await query.run { scope in
            let page = try await scope.page.find(id: id)
            return .init(
                id: page.id,
                title: page.title,
                excerpt: page.excerpt,
                content: page.content,
                imageAssetId: page.imageAssetId,
                metadata: page.metadata,
                createdAt: page.createdAt,
                updatedAt: page.updatedAt
            )
        }
    }
}
