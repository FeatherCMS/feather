public import FeatherApplication
public import FeatherModuleKit
public import NewsDomain
import NewsContracts
import WebApplication
import WebDomain

//
//  GetCategory.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct GetCategory: UseCase {
    struct Action: PermissionAction {
        let key = NewsPermissions.Categories.read
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadCategoryMetadata>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadCategoryMetadata>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public func execute(
        subject: Subject,
        input: Category.Detail.Input
    ) async throws -> Category.Detail.Output {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let id = input.id

        return try await query.run { scope in
            let category = try await scope.category.find(id: id)
            guard
                let metadata = try await scope.metadata.find(
                    referenceType: "news.category",
                    referenceID: id
                )
            else {
                throw Error(message: "Category metadata not found")
            }
            return .init(
                id: category.id,
                title: category.title,
                excerpt: category.excerpt,
                content: category.content,
                imageAssetId: category.imageAssetId,
                metadata: metadata,
                createdAt: category.createdAt,
                updatedAt: category.updatedAt
            )
        }
    }
}
