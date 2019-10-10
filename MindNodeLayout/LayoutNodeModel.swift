//
//  LayoutNodeModel.swift
//  MindNodeLayout
//
//  Created by anthann on 2019/10/10.
//  Copyright © 2019 anthann. All rights reserved.
//

import Foundation
import CoreGraphics

/// 用于布局的节点Model
class LayoutNodeModel {
    let identifier: String
    /// bounding是包含了margin的
    var boundingX: CGFloat = 0
    var boundingY: CGFloat = 0
    var boundingWidth: CGFloat = 0
    var boundingHeight: CGFloat = 0
    var marginTop: CGFloat = 0
    var marginBottom: CGFloat = 0
    var marginLeft: CGFloat = 0
    var marginRight: CGFloat = 0
    /// 以本节点为根的子树的宽度和高度
    var treeWidth: CGFloat = 0
    var treeHeight: CGFloat = 0
    var children: [LayoutNodeModel] = []
    
    init(identifier: String) {
        self.identifier = identifier
    }
}

//MARK: - Getters
extension LayoutNodeModel {
    var width: CGFloat {
        return boundingWidth - marginLeft - marginRight
    }
    
    var height: CGFloat {
        return boundingHeight - marginTop - marginBottom
    }
    
    var x: CGFloat {
        return boundingX + marginLeft
    }
    
    var y: CGFloat {
        return boundingY + marginTop
    }
    
    var outEdgePoint: CGPoint {
        return CGPoint(x: x + width, y: y + 0.5 * height)
    }
    
    var inEdgePoint: CGPoint {
        return CGPoint(x: x, y: y + 0.5 * height)
    }
}
