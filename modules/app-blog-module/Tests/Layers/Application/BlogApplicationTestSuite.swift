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
        let queries = PostQueriesMock()
        let metadata = MetadataQueryMock()
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Post.Detail.Scope(post: queries, metadata: metadata)
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
        let queries = PostQueriesMock()
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Post.Search.Scope(post: queries)
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
}

private struct AuthorListQueryMock: Author.List.Query.Interface {
    func list() async throws -> Author.List.Output {
        throw TestError.unexpectedCall
    }
}

private struct PostQueriesMock: Post.Query.Interface {
    func find(id: String) async throws -> Post.Detail.Output {
        throw TestError.unexpectedCall
    }

    func list(query: Post.Search.Input.Query) async throws -> Post.List.Output {
        .init(items: [])
    }

    func count(query: Post.Search.Input.Query) async throws -> Int {
        0
    }
}

private struct MetadataQueryMock: Metadata.Query.Interface {
    func find(id: String) async throws -> MetadataDetail {
        throw TestError.unexpectedCall
    }

    func find(referenceType: String, referenceID: String) async throws
        -> MetadataDetail?
    {
        throw TestError.unexpectedCall
    }

    func find(referenceType: String, slug: String) async throws
        -> MetadataDetail?
    {
        throw TestError.unexpectedCall
    }

    func resolve(slug: String) async throws -> MetadataDetail? {
        throw TestError.unexpectedCall
    }

    func listPublic() async throws -> [MetadataList.Item] {
        throw TestError.unexpectedCall
    }

    func list(query: MetadataList.Query) async throws -> MetadataList {
        throw TestError.unexpectedCall
    }

    func resolve(referenceType: String, referenceIDs: [String]) async throws
        -> [MetadataList.Item]
    {
        throw TestError.unexpectedCall
    }

    func resolveDetails(referenceType: String, referenceIDs: [String])
        async throws
        -> [MetadataDetail]
    {
        throw TestError.unexpectedCall
    }

    func count(query: MetadataList.Query) async throws -> Int {
        throw TestError.unexpectedCall
    }
}

private enum TestError: Error {
    case unexpectedCall
}
