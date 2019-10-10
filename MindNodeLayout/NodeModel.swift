//
//  NodeModel.swift
//  MindNodeLayout
//
//  Created by anthann on 2019/10/10.
//  Copyright © 2019 anthann. All rights reserved.
//

import UIKit

/// 业务逻辑中的数据Model。不直接用于布局。
class NodeModel {
    static var numOfNodes: Int = 50
    let identifier: String
    let width: CGFloat
    let height: CGFloat
    let color: UIColor = UIColor.random
    var children: [NodeModel] = []
    
    init() {
        identifier = UUID().uuidString
        width = .random(in: 100...200)
        height = .random(in: 120...360)
        if NodeModel.numOfNodes < 0 {
            return
        }
        let numOfChildren: Int = .random(in: 0..<5)
        NodeModel.numOfNodes -= numOfChildren
        for _ in 0..<numOfChildren {
            children.append(NodeModel())
        }
        children.shuffle()
    }
}

extension NodeModel: LayoutNodeProtocol {
    var downStream: [LayoutNodeProtocol] {
        return children
    }
    
    var nodeId: String {
        return identifier
    }
    
    var contentWidth: CGFloat {
        return width
    }
    
    var contentHeight: CGFloat {
        return height
    }
    
    var marginLeft: CGFloat {
        return 150
    }
    
    var marginRight: CGFloat {
        return 150
    }
    
    var marginTop: CGFloat {
        return 30
    }
    
    var marginBottom: CGFloat {
        return 30
    }
}
