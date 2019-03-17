//
//  ClashProxy.swift
//  ClashX
//
//  Created by CYC on 2019/3/17.
//  Copyright © 2019 west2online. All rights reserved.
//

import Cocoa

enum ClashProxyType:String,Codable {
    case urltest = "URLTest"
    case fallback = "Fallback"
    case loadBalance = "LoadBalance"
    case select = "Selector"
    case direct = "Direct"
    case reject = "Reject"
    case shadowsocks = "Shadowsocks"
    case socks5 = "Socks5"
    case http = "Http"
    case vmess = "Vmess"
    case unknow = "Unknow"
}

typealias ClashProxyName = String

class ClashProxySpeedHistory:Codable {
    let time:Date
    let delay:Int
}



class ClashProxy:Codable {
    var name:ClashProxyName = ""
    let type:ClashProxyType
    let all:[ClashProxyName]?
    let history:[ClashProxySpeedHistory]
    let now:ClashProxyName?
    
    private enum CodingKeys : String, CodingKey {
        case type,all,history,now
    }
    
    static func fromData(_ data:Any?)->[ClashProxy]{
        guard
            let data = data as? [String:[String:Any]],
            let proxies = data["proxies"]
        else {return []}
        
        var proxiesModel = [ClashProxy]()
        
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        for (key,value) in proxies {
            guard let data = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
                continue
            }
            guard let proxy = try? decoder.decode(ClashProxy.self, from: data) else {
                continue
            }
            proxy.name = key
            proxiesModel.append(proxy)
        }

        return proxiesModel
    }
}

