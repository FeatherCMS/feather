public import BlogModule
public import FeatherApplication
public import FeatherModuleKit
import WebApplication

//
//  GetPost.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Post.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        struct Error: UseCaseError {
            let message: String
        }

        let authorizer: any Authorizer
        let query: any QueryExecutor<Post.Detail.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Post.Detail.Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Post.Detail.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let id = input.id

            return try await query.run { scope in
                let post = try await scope.post.find(id: id)
                guard
                    let metadata = try await scope.metadata.find(
                        referenceType: "blog.post",
                        referenceID: id
                    )
                else {
                    throw Error(message: "Post metadata not found")
                }
                return .init(
                    id: post.id,
                    title: post.title,
                    excerpt: post.excerpt,
                    content: post.content,
                    imageAssetId: post.imageAssetId,
                    authorIds: post.authorIds,
                    tagIds: post.tagIds,
                    metadata: metadata,
                    createdAt: post.createdAt,
                    updatedAt: post.updatedAt
                )
            }
        }
    }
}
