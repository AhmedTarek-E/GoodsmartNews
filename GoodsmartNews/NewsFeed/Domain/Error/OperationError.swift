//
//  OperationError.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 03/06/2022.
//

import Foundation

public class OperationError: LocalizedError {
    public init(_ errorDescription: String) {
        self.errorDescription = errorDescription
    }
    
    public var errorDescription: String?
}

public class UnexpectedError: LocalizedError {
    public init(_ errorDescription: String) {
        self.errorDescription = errorDescription
    }
    
    public var errorDescription: String?
}
