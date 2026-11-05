//
//  BlogApplication+UseCases+Tests.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 07. 16.

import BlogApplication
import BlogDomain
import BlogModule
import FeatherApplication
import FeatherDomain
import FeatherModuleKit
import FeatherTesting
import Foundation
import Testing
import WebApplication
import WebDomain

import enum BlogModule.Tag

@testable import BlogApplication

@Suite
struct BlogApplicationUseCasesTests {

    @Test
    func getPostChecksAuthorizationBeforeQuerying() async throws {
        let query = PostDetailQueryMock()
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Post.Detail.Scope(post: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = Post.Detail.UseCase(
            authorizer: authorizer,
            query: executor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "user-1"),
                input: Post.Detail.Input(id: "post-1")
            )
        }

        #expect(await authorizer.canCallCount == 1)
        #expect(await executor.runCallCount == 0)
    }

    @Test
    func listAuthorsChecksAuthorizationBeforeQuerying() async throws {
        let authorQuery = AuthorListQueryMock()
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Author.List.Scope(author: authorQuery)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = Author.List.UseCase(
            authorizer: authorizer,
            query: executor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "user-1"),
                input: .init()
            )
        }

        #expect(await authorizer.canCallCount == 1)
        #expect(await executor.runCallCount == 0)
    }

    @Test
    func searchPostsReturnsRowsAndTotalFromTheQuery() async throws {
        let query = PostSearchQueryMock()
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Post.Search.Scope(post: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Post.Search.UseCase(
            authorizer: authorizer,
            query: executor
        )

        let output = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(query: .init())
        )

        #expect(output.items.isEmpty)
        #expect(output.total == 0)
        #expect(await authorizer.canCallCount == 1)
        #expect(await executor.runCallCount == 1)
    }

    @Test
    func listPostsReturnsQueryResults() async throws {
        let query = PostListQueryMock()
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Post.List.Scope(post: query)
        )
        let useCase = Post.List.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            query: executor
        )

        let output = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init()
        )

        #expect(output.items.isEmpty)
        #expect(await executor.runCallCount == 1)
    }

    @Test
    func searchAuthorsReturnsRowsAndTotalFromTheQuery() async throws {
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Author.Search.Scope(author: AuthorSearchQueryMock())
        )
        let useCase = Author.Search.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            query: executor
        )

        let output = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(query: .init(search: "writer"))
        )

        #expect(output.items.isEmpty)
        #expect(output.total == 2)
        #expect(await executor.runCallCount == 1)
    }

    @Test
    func searchAuthorLinksReturnsRowsAndTotalFromTheQuery() async throws {
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: AuthorLink.Search.Scope(
                authorLink: AuthorLinkSearchQueryMock()
            )
        )
        let useCase = AuthorLink.Search.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            query: executor
        )

        let output = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(authorId: "author-1", query: .init(search: "site"))
        )

        #expect(output.items.isEmpty)
        #expect(output.total == 1)
        #expect(await executor.runCallCount == 1)
    }

    @Test
    func detailAuthorChecksAuthorizationBeforeQuerying() async throws {
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Author.Detail.Scope(author: AuthorDetailQueryMock())
        )
        let useCase = Author.Detail.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "user-1"),
                input: .init(id: "author-1")
            )
        }

        #expect(await executor.runCallCount == 0)
    }

    @Test
    func searchAuthorsChecksAuthorizationBeforeQuerying() async throws {
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Author.Search.Scope(author: AuthorSearchQueryMock())
        )
        let useCase = Author.Search.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "user-1"),
                input: .init(query: .init())
            )
        }

        #expect(await executor.runCallCount == 0)
    }

    @Test
    func detailAuthorLinksChecksAuthorizationBeforeQuerying() async throws {
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: AuthorLink.Detail.Scope(
                authorLink: AuthorLinkDetailQueryMock()
            )
        )
        let useCase = AuthorLink.Detail.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "user-1"),
                input: .init(id: "author-link-1", authorId: "author-1")
            )
        }

        #expect(await executor.runCallCount == 0)
    }

    @Test
    func listAuthorLinksChecksAuthorizationBeforeQuerying() async throws {
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: AuthorLink.List.Scope(
                authorLink: AuthorLinkListQueryMock()
            )
        )
        let useCase = AuthorLink.List.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "user-1"),
                input: .init(authorId: "author-1")
            )
        }

        #expect(await executor.runCallCount == 0)
    }

    @Test
    func searchAuthorLinksChecksAuthorizationBeforeQuerying() async throws {
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: AuthorLink.Search.Scope(
                authorLink: AuthorLinkSearchQueryMock()
            )
        )
        let useCase = AuthorLink.Search.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "user-1"),
                input: .init(authorId: "author-1", query: .init())
            )
        }

        #expect(await executor.runCallCount == 0)
    }

    @Test
    func listPostsChecksAuthorizationBeforeQuerying() async throws {
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Post.List.Scope(post: PostListQueryMock())
        )
        let useCase = Post.List.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "user-1"),
                input: .init()
            )
        }

        #expect(await executor.runCallCount == 0)
    }

    @Test
    func detailTagsChecksAuthorizationBeforeQuerying() async throws {
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Tag.Detail.Scope(tag: TagDetailQueryMock())
        )
        let useCase = Tag.Detail.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "user-1"),
                input: .init(id: "tag-1")
            )
        }

        #expect(await executor.runCallCount == 0)
    }

    @Test
    func listTagsChecksAuthorizationBeforeQuerying() async throws {
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Tag.List.Scope(tag: TagListQueryMock())
        )
        let useCase = Tag.List.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "user-1"),
                input: .init()
            )
        }

        #expect(await executor.runCallCount == 0)
    }

    @Test
    func searchTagsChecksAuthorizationBeforeQuerying() async throws {
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Tag.Search.Scope(tag: TagSearchQueryMock())
        )
        let useCase = Tag.Search.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "user-1"),
                input: .init(query: .init())
            )
        }

        #expect(await executor.runCallCount == 0)
    }

    @Test
    func addAuthorLinkChecksAuthorizationBeforeStartingTransaction()
        async throws
    {
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: AuthorLink.Add.Scope(
                authorLink: AuthorLinkRepositoryMock()
            )
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = AuthorLink.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "user-1"),
                input: .init(
                    authorId: "author-1",
                    label: "Website",
                    url: "https://example.com",
                    priority: 0,
                    isBlank: false,
                    permission: "",
                    notes: ""
                )
            )
        }

        #expect(await authorizer.canCallCount == 1)
        #expect(await transaction.runCallCount == 0)
    }

    @Test
    func addAuthorLinkReturnsTheInsertedModel() async throws {
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: AuthorLink.Add.Scope(
                authorLink: AuthorLinkRepositoryMock()
            )
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = AuthorLink.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        let output = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(
                authorId: "author-1",
                label: "Website",
                url: "https://example.com",
                priority: 0,
                isBlank: false,
                permission: "",
                notes: ""
            )
        )

        #expect(output.id == "author-link-1")
        #expect(output.authorId == "author-1")
        #expect(output.label == "Website")
        #expect(await authorizer.canCallCount == 1)
        #expect(await transaction.runCallCount == 1)
    }

    @Test
    func editAuthorLinkChecksAuthorizationBeforeStartingTransaction()
        async throws
    {
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: AuthorLink.Edit.Scope(
                authorLink: AuthorLinkRepositoryMock()
            )
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = AuthorLink.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "user-1"),
                input: .init(
                    id: "author-link-1",
                    authorId: "author-1",
                    label: .unchanged,
                    url: .unchanged,
                    priority: .unchanged,
                    isBlank: .unchanged,
                    permission: .unchanged,
                    notes: .unchanged
                )
            )
        }

        #expect(await authorizer.canCallCount == 1)
        #expect(await transaction.runCallCount == 0)
    }

    @Test
    func editAuthorLinkReturnsTheUpdatedModel() async throws {
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: AuthorLink.Edit.Scope(
                authorLink: AuthorLinkRepositoryMock()
            )
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = AuthorLink.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        let output = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(
                id: "author-link-1",
                authorId: "author-1",
                label: .set("Updated website"),
                url: .unchanged,
                priority: .unchanged,
                isBlank: .unchanged,
                permission: .unchanged,
                notes: .unchanged
            )
        )

        #expect(output.label == "Updated website")
        #expect(output.url == "https://example.com")
        #expect(await authorizer.canCallCount == 1)
        #expect(await transaction.runCallCount == 1)
    }

    @Test
    func removeAuthorLinksChecksAuthorizationBeforeStartingTransaction()
        async throws
    {
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: AuthorLink.Remove.Scope(
                authorLink: AuthorLinkRepositoryMock()
            )
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = AuthorLink.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "user-1"),
                input: .init(ids: ["author-link-1"], authorId: "author-1")
            )
        }

        #expect(await authorizer.canCallCount == 1)
        #expect(await transaction.runCallCount == 0)
    }

    @Test
    func removeAuthorLinksReturnsDeletedIDs() async throws {
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: AuthorLink.Remove.Scope(
                authorLink: AuthorLinkRepositoryMock()
            )
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = AuthorLink.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        let output = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(ids: ["author-link-1"], authorId: "author-1")
        )

        #expect(output.ids == ["author-link-1"])
        #expect(await authorizer.canCallCount == 1)
        #expect(await transaction.runCallCount == 1)
    }
}

private struct AuthorListQueryMock: Author.List.Query.Interface {
    func list() async throws -> Author.List.Output {
        throw TestError.unexpectedCall
    }
}

private struct AuthorDetailQueryMock: Author.Detail.Query.Interface {
    func find(id: String) async throws -> Author.Detail.Output {
        throw TestError.unexpectedCall
    }
}

private struct PostDetailQueryMock: Post.Detail.Query.Interface {
    func find(id: String) async throws -> Post.Detail.Output {
        throw TestError.unexpectedCall
    }
}

private struct PostSearchQueryMock: Post.Search.Query.Interface {
    func search(query: Post.Search.Input.Query) async throws
        -> Post.Search.Output
    {
        .init(items: [], total: 0)
    }
}

private struct PostListQueryMock: Post.List.Query.Interface {
    func list() async throws -> Post.List.Output {
        .init(items: [])
    }
}

private struct AuthorSearchQueryMock: Author.Search.Query.Interface {
    func search(query: Author.Search.Input.Query) async throws
        -> Author.Search.Output
    {
        .init(items: [], total: 2)
    }
}

private struct AuthorLinkSearchQueryMock: AuthorLink.Search.Query.Interface {
    func search(
        authorId: String,
        query: AuthorLink.Search.Input.Query
    ) async throws -> AuthorLink.Search.Output {
        .init(items: [], total: 1)
    }
}

private struct AuthorLinkDetailQueryMock: AuthorLink.Detail.Query.Interface {
    func find(id: String) async throws -> AuthorLink.Detail.Output {
        throw TestError.unexpectedCall
    }
}

private struct AuthorLinkListQueryMock: AuthorLink.List.Query.Interface {
    func list(authorId: String) async throws -> AuthorLink.List.Output {
        throw TestError.unexpectedCall
    }
}

private struct AuthorLinkRepositoryMock: AuthorLink.Repository.Interface {
    func find(id: String) async throws -> AuthorLink.Model? {
        guard id == "author-link-1" else { return nil }
        return model
    }

    func insert(_ model: AuthorLink.Model.New) async throws -> AuthorLink.Model
    {
        .init(
            id: "author-link-1",
            authorId: model.authorId,
            label: model.label,
            url: model.url,
            priority: model.priority,
            isBlank: model.isBlank,
            permission: model.permission,
            notes: model.notes,
            createdAt: Date(timeIntervalSince1970: 0),
            updatedAt: Date(timeIntervalSince1970: 0)
        )
    }

    func update(_ model: AuthorLink.Model) async throws -> AuthorLink.Model {
        model
    }

    func delete(ids: [String]) async throws -> [String] {
        ids
    }

    private var model: AuthorLink.Model {
        .init(
            id: "author-link-1",
            authorId: "author-1",
            label: "Website",
            url: "https://example.com",
            priority: 0,
            isBlank: false,
            permission: "",
            notes: "",
            createdAt: Date(timeIntervalSince1970: 0),
            updatedAt: Date(timeIntervalSince1970: 0)
        )
    }
}

private struct TagDetailQueryMock: Tag.Detail.Query.Interface {
    func find(id: String) async throws -> Tag.Detail.Output {
        throw TestError.unexpectedCall
    }
}

private struct TagListQueryMock: Tag.List.Query.Interface {
    func list() async throws -> Tag.List.Output {
        throw TestError.unexpectedCall
    }
}

private struct TagSearchQueryMock: Tag.Search.Query.Interface {
    func search(
        query: Tag.Search.Input.Query
    ) async throws -> Tag.Search.Output {
        throw TestError.unexpectedCall
    }
}

private enum TestError: Error {
    case unexpectedCall
}
