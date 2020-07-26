//
//  RedirectEditForm.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 02. 17..
//

import Vapor
import ViewKit

final class RedirectEditForm: Form {

    typealias Model = RedirectModel

    struct Input: Decodable {
        var id: String
        var source: String
        var destination: String
        var statusCode: String
    }

    var id: String? = nil
    var source = BasicFormField()
    var destination = BasicFormField()
    var statusCode = SelectionFormField()
    
    var notification: String?
    
    private let validCodes = [301, 303, 307]
        
    init() {
        self.initialize()
    }

    init(req: Request) throws {
        self.initialize()

        let context = try req.content.decode(Input.self)
        self.id = context.id.emptyToNil

        self.source.value = context.source
        self.destination.value = context.destination
        self.statusCode.value = context.statusCode
    }
    
    func initialize() {
        self.statusCode.options = FormFieldOption.numbers(self.validCodes)
        self.statusCode.value = String(self.validCodes[0])
    }
    
    func read(from model: Model)  {
        
        self.id = model.id!.uuidString
        self.source.value = model.source
        self.destination.value = model.destination
        self.statusCode.value = String(model.statusCode)
    }

    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
       
        if self.source.value.isEmpty {
            self.source.error = "Source is required"
            valid = false
        }
        if self.destination.value.isEmpty {
            self.destination.error = "Destination is required"
            valid = false
        }
        let statusCode = Int(self.statusCode.value)
        if self.statusCode.value.isEmpty || statusCode == nil || !self.validCodes.contains(statusCode!) {
            self.statusCode.error = "Invalid status code"
            valid = false
        }

        return req.eventLoop.future(valid)
    }
    
    func write(to model: Model) {
        model.source = self.source.value
        model.destination = self.destination.value
        model.statusCode = Int(self.statusCode.value)!
    }
}
