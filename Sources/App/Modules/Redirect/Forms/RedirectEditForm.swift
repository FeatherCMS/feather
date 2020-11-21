//
//  RedirectEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 02. 17..
//

import FeatherCore

final class RedirectEditForm: ModelForm {

    typealias Model = RedirectModel

    struct Input: Decodable {
        var modelId: String
        var source: String
        var destination: String
        var statusCode: String
    }

    var modelId: String? = nil
    var source = StringFormField()
    var destination = StringFormField()
    var statusCode = StringSelectionFormField()
    var notification: String?

    var leafData: LeafData {
        .dictionary([
            "modelId": modelId,
            "source": source,
            "destination": destination,
            "statusCode": statusCode,
            "notification": notification,
        ])
    }
    
    private let validCodes = [301, 303, 307]
        
    init() {
        initialize()
    }

    init(req: Request) throws {
        initialize()

        let context = try req.content.decode(Input.self)
        modelId = context.modelId.emptyToNil
        source.value = context.source
        destination.value = context.destination
        statusCode.value = context.statusCode
    }
    
    func initialize() {
        statusCode.options = FormFieldStringOption.numbers(validCodes)
        statusCode.value = String(validCodes[0])
    }

    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
       
        if source.value.isEmpty {
            source.error = "Source is required"
            valid = false
        }
        if Validator.count(...250).validate(source.value).isFailure {
            source.error = "Source is too long (max 250 characters)"
            valid = false
        }
        if destination.value.isEmpty {
            destination.error = "Destination is required"
            valid = false
        }
        if Validator.count(...250).validate(destination.value).isFailure {
            destination.error = "Destination is too long (max 250 characters)"
            valid = false
        }
        let code = Int(statusCode.value)
        if statusCode.value.isEmpty || code == nil || !validCodes.contains(code!) {
            statusCode.error = "Invalid status code"
            valid = false
        }

        return req.eventLoop.future(valid)
    }

    func read(from input: Model)  {
        modelId = input.id?.uuidString
        source.value = input.source
        destination.value = input.destination
        statusCode.value = String(input.statusCode)
    }

    func write(to output: Model) {
        output.source = source.value
        output.destination = destination.value
        output.statusCode = Int(statusCode.value)!
    }
}
