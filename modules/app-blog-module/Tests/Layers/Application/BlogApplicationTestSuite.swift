//
//  BlogApplicationTestSuite.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 07. 16.

import BlogApplication
import BlogModule
import FeatherApplication
import FeatherModuleKit
import FeatherTesting
import Testing
import WebApplication
import WebDomain

@testable import BlogApplication

@Suite
struct BlogApplicationTestSuite {

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
}

private struct AuthorListQueryMock: Author.List.Query.Interface {
    func list() async throws -> Author.List.Output {
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

private enum TestError: Error {
    case unexpectedCall
}
