//
//  File.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

import SystemDomain

actor VariableMockRepository: VariableRepository {

    private(set) var lastCreateInput: Variable.New?
    private(set) var createCallCount = 0
    private(set) var updateCallCount = 0
    private(set) var findCallCount = 0
    private(set) var deleteCallCount = 0
    private(set) var lastFindId: String?
    private(set) var lastDeleteId: String?

    private let result: Result<Variable, Error>
    private let findResult: Variable?
    private let deleteResult: Bool

    init(
        result: Result<Variable, Error>,
        findResult: Variable? = nil,
        deleteResult: Bool = false
    ) {
        self.result = result
        self.findResult = findResult
        self.deleteResult = deleteResult
    }

    func insert(
        _ model: Variable.New
    ) async throws -> Variable {
        createCallCount += 1
        lastCreateInput = model
        return try result.get()
    }

    func update(
        _ model: Variable
    ) async throws -> Variable {
        updateCallCount += 1
        return model
    }

    func find(
        id: String
    ) async throws -> Variable? {
        findCallCount += 1
        lastFindId = id
        return findResult
    }

    func delete(
        id: String
    ) async throws -> Bool {
        deleteCallCount += 1
        lastDeleteId = id
        return deleteResult
    }
}
