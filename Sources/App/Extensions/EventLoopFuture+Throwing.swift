//
//  EventLoopFuture+Throwing.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 03. 27..
//

import Vapor

extension EventLoopFuture {
    
    func throwingFlatMap<NewValue>(file: StaticString = #file,
                        line: UInt = #line,
                        _ callback: @escaping (Value) throws -> EventLoopFuture<NewValue>) -> EventLoopFuture<NewValue> {
        self.flatMap(file: file, line: line) { value in
            do {
                return try callback(value)
            }
            catch {
                return self.eventLoop.makeFailedFuture(error, file: file, line: line)
            }
        }
    }

    func throwingMap<NewValue>(file: StaticString = #file,
                           line: UInt = #line,
                           _ callback: @escaping (Value) throws -> NewValue) -> EventLoopFuture<NewValue> {
        self.flatMapThrowing(file: file, line: line, callback)
    }
}
