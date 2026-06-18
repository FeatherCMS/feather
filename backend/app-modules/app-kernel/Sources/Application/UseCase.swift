//
//  File.swift
//  app-kernel
//
//  Created by Tibor Bödecs on 2026. 04. 10..
//

public protocol UseCase: Sendable {}

//public protocol InputOnlyUseCase: UseCase {
//    associatedtype Input: DTO
//
//    func execute(
//        _ input: Input
//    ) async throws
//}
//
//public protocol OutputOnlyUseCase: UseCase {
//
//    associatedtype Output: DTO
//
//    func execute(
//
//    ) async throws -> Output
//}
//
//
//public protocol StandardUseCase: UseCase {
//    associatedtype Input: DTO
//    associatedtype Output: DTO
//
//    func execute(
//        _ input: Input
//    ) async throws -> Output
//}
//
//public protocol AuthorizedUseCase: UseCase {
//    associatedtype Input: DTO
//    associatedtype Output: DTO
//
//    var authorizer: any Authorizer { get }
//    var action: Action { get }
//
//    func execute(
//        subject: Subject,
//        input: Input
//    ) async throws -> Output
//}
