//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//

import FeatherCore

final class AnalyticsLogModel: ViperModel {

    typealias Module = AnalyticsModule

    static let name = "logs"

    struct FieldKeys {
        static var date: FieldKey { "date" }
        static var session: FieldKey { "session" }

        static var method: FieldKey { "method" }
        static var url: FieldKey { "url" }
        static var headers: FieldKey { "headers" }
        static var ip: FieldKey { "ip" }
        
        static var path: FieldKey { "path" }
        static var referer: FieldKey { "referer" }
        static var origin: FieldKey { "origin" }
        static var language: FieldKey { "language" }
        static var region: FieldKey { "region" }

        static var osName: FieldKey { "os_name" }
        static var osVersion: FieldKey { "os_version" }
        static var browserName: FieldKey { "browser_name" }
        static var browserVersion: FieldKey { "browser_version" }
        static var engineName: FieldKey { "engine_name" }
        static var engineVersion: FieldKey { "engine_version" }
        static var deviceVendor: FieldKey { "device_vendor" }
        static var deviceType: FieldKey { "device_type" }
        static var deviceModel: FieldKey { "device_model" }
        static var cpu: FieldKey { "cpu" }
    }

    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.date) var date: Date
    @Field(key: FieldKeys.session) var session: String?
    @Field(key: FieldKeys.method) var method: String
    @Field(key: FieldKeys.url) var url: String
    @Field(key: FieldKeys.headers) var headers: [String: String]
    @Field(key: FieldKeys.ip) var ip: String?
    
    @Field(key: FieldKeys.path) var path: String
    @Field(key: FieldKeys.referer) var referer: String?
    @Field(key: FieldKeys.origin) var origin: String?
    @Field(key: FieldKeys.language) var language: String?
    @Field(key: FieldKeys.region) var region: String?
    
    @Field(key: FieldKeys.osName) var osName: String?
    @Field(key: FieldKeys.osVersion) var osVersion: String?
    @Field(key: FieldKeys.browserName) var browserName: String?
    @Field(key: FieldKeys.browserVersion) var browserVersion: String?
    @Field(key: FieldKeys.engineName) var engineName: String?
    @Field(key: FieldKeys.engineVersion) var engineVersion: String?
    @Field(key: FieldKeys.deviceVendor) var deviceVendor: String?
    @Field(key: FieldKeys.deviceType) var deviceType: String?
    @Field(key: FieldKeys.deviceModel) var deviceModel: String?
    @Field(key: FieldKeys.cpu) var cpu: String?

    init() { }

    init(id: AnalyticsLogModel.IDValue? = nil,
         date: Date = Date(),
         session: String?,
         method: String,
         url: String,
         headers: [String:String],
         ip: String? = nil,
         
         path: String,
         referer: String? = nil,
         origin: String? = nil,
         language: String? = nil,
         region: String? = nil,
         
         osName: String? = nil,
         osVersion: String? = nil,
         browserName: String? = nil,
         browserVersion: String? = nil,
         engineName: String? = nil,
         engineVersion: String? = nil,
         deviceVendor: String? = nil,
         deviceType: String? = nil,
         deviceModel: String? = nil,
         cpu: String? = nil)
    {
        self.id = id
        self.date = date
        self.session = session
        self.method = method
        self.url = url
        self.headers = headers
        self.ip = ip
        
        self.path = path
        self.referer = referer
        self.origin = origin
        self.language = language
        self.region = region
        
        self.osName = osName
        self.osVersion = osVersion
        self.browserName = browserName
        self.browserVersion = browserVersion
        self.engineName = engineName
        self.engineVersion = engineVersion
        self.deviceVendor = deviceVendor
        self.deviceType = deviceType
        self.deviceModel = deviceModel
        self.cpu = cpu
    }
    

    
}
