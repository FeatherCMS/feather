//
//  SystemVariableMiddleware.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 10..
//

import Vapor
import Fluent

struct SystemVariableMiddleware: Middleware {

    public func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        SystemVariableModel.query(on: req.db).all().map { variables in
            for variable in variables {
                req.variables.cache.storage[variable.key] = variable.value
            }
        }
        .flatMap { next.respond(to: req) }
    }
}

extension Request {

    public var variables: Variables {
        return .init(request: self)
    }

    public struct Variables {
        let request: Request
        init(request: Request) {
            self.request = request
        }
    }
}

extension Request.Variables {
    
    private struct CacheKey: StorageKey {
        typealias Value = Cache
    }

    fileprivate var cache: Cache {
        get {
            if let existing = self.request.storage[CacheKey.self] {
                return existing
            }
            let new = Cache()
            self.request.storage[CacheKey.self] = new
            return new
        }
        set {
            self.request.storage[CacheKey.self] = newValue
        }
    }

    fileprivate final class Cache {
        fileprivate var storage: [String: String] = [:]
    }
    
    public func get(_ key: String) -> String {
        self.cache.storage[key] ?? ""
    }

    public func has(_ key: String) -> Bool {
        self.cache.storage[key] != nil
    }

    public func set(_ key: String, value: String, hidden: Bool? = nil, notes: String? = nil) -> EventLoopFuture<Void> {
        SystemVariableModel
            .query(on: self.request.db)
            .filter(\.$key == key)
            .first()
            .flatMap { model -> EventLoopFuture<Void> in
                if let model = model {
                    model.value = value
                    if let hidden = hidden {
                        model.hidden = hidden
                    }
                    model.notes = notes
                    return model.update(on: self.request.db)
                }
                return SystemVariableModel(key: key,
                                           value: value,
                                           hidden: hidden ?? false,
                                           notes: notes)
                    .create(on: self.request.db)
            }
            .map { self.cache.storage[key] = value }
    }

    public func unset(_ key: String) -> EventLoopFuture<Void> {
        SystemVariableModel
            .query(on: self.request.db)
            .filter(\.$key == key)
            .delete()
            .map { self.cache.storage[key] = nil }
    }
}
