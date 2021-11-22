//
//  GoogleService.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/17/21.
//

import Foundation

public class GoogleService<T>: WebService<T> {
    override open func load(shouldEncodePlusSign: Bool = false, completion:@escaping (Response<T, Error>) -> ()) {
        let resource = Resource<T>(urlString: urlString, httpMethod: httpMethod, parameters: parameters, httpBodyData: httpBodyData, headers: headers, parse: parse)
        resource.shouldEncodePlusSign = shouldEncodePlusSign
        load(resource: resource, completion: completion)
    }
    
    open var jsonDecoder: JSONDecoder {
        return JSONDecoder()
    }

    open var jsonEncoder: JSONEncoder {
        return JSONEncoder()
    }

}
