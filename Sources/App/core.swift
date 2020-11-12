//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 06..
//

import FeatherCore

extension ViperModel where Self: LeafDataRepresentable {
    
    func joinedMetadata() -> LeafData {
        var data: [String: LeafData] = leafData.dictionary!
        data["metadata"] = try! joined(Metadata.self).leafData
        return .dictionary(data)
    }
}

extension Request {
    
    func hookAll<T>(_ name: String, type: T.Type, params: [String : Any] = [:]) -> EventLoopFuture<[T]> {
        application.viper.invokeAllHooks(name: name, req: self, type: type, params: params)
    }
    
    func hook<T>(_ name: String, type: T.Type, params: [String : Any] = [:]) -> EventLoopFuture<T?> {
        application.viper.invokeHook(name: name, req: self, type: type, params: params)
    }
    
    func syncHookAll<T>(_ name: String, type: T.Type, params: [String : Any] = [:]) -> [T] {
        application.viper.invokeAllSyncHooks(name: name, req: self, type: type, params: params)
    }
    func syncHook<T>(_ name: String, type: T.Type, params: [String : Any] = [:]) -> T? {
        application.viper.invokeSyncHook(name: name, req: self, type: type, params: params)
    }
}
