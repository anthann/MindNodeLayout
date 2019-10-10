//
//  Layout.swift
//  MindNodeLayout
//
//  Created by anthann on 2019/10/10.
//  Copyright © 2019 anthann. All rights reserved.
//

import Foundation
import CoreGraphics

/// 布局逻辑。目前实现了从左向右排列的布局逻辑
class Layout {
    var offset: CGPoint = CGPoint.zero
    var layoutTree: LayoutNodeModel?
    var edges: [EdgeModel]?
    
    func layout(root: LayoutNodeProtocol) {
        let layoutTree = getLayoutTree(root: root)
        layer(root: layoutTree, left: offset.x)
        firstTraverse(root: layoutTree)
        let edges = secondTraverse(root: layoutTree, top: offset.y)
        self.layoutTree = layoutTree
        self.edges = edges
    }
    
    // 构造布局树
    private func getLayoutTree(root: LayoutNodeProtocol) -> LayoutNodeModel {
        let model = LayoutNodeModel(identifier: root.nodeId)
        model.boundingWidth = root.contentWidth + root.marginLeft + root.marginRight
        model.boundingHeight = root.contentHeight + root.marginTop + root.marginBottom
        model.marginTop = root.marginTop
        model.marginBottom = root.marginBottom
        model.marginLeft = root.marginLeft
        model.marginRight = root.marginRight
        model.children = root.downStream.map({ m in
            return self.getLayoutTree(root: m)
        })
        return model
    }
    
    // 从左到右设置各个的originl.x值
    private func layer(root: LayoutNodeModel, left: CGFloat = 0) {
        root.boundingX = left
        root.children.forEach { (m) in
            self.layer(root: m, left: left + root.boundingWidth)
        }
    }
    
    // 后根遍历，计算以每个节点为根的子树所需的空间
    private func firstTraverse(root: LayoutNodeModel) {
        if root.children.isEmpty {
            root.treeWidth = root.boundingWidth
            root.treeHeight = root.boundingHeight
        } else {
            var treeWidth: CGFloat = 0
            var treeHeight: CGFloat = 0
            for child in root.children {
                firstTraverse(root: child)
                treeWidth = max(child.treeWidth, treeWidth)
                treeHeight += child.treeHeight
            }
            root.treeWidth = root.boundingWidth + treeWidth
            root.treeHeight = max(root.boundingHeight, treeHeight)
        }
    }
    
    // 先根遍历，调整每个节点的origin.y，并构造和返回edges
    private func secondTraverse(root: LayoutNodeModel, top: CGFloat = 0) -> [EdgeModel] {
        var edges: [EdgeModel] = []
        root.boundingY = top + (root.treeHeight - root.boundingHeight) * 0.5
        var offset: CGFloat = 0
        for child in root.children {
            edges.append(contentsOf: secondTraverse(root: child, top: top + offset))
            offset += child.treeHeight
            let edge = EdgeModel(fromNodeIdentifier: root.identifier, toNodeIdentifier: child.identifier, fromPoint: root.outEdgePoint, toPoint: child.inEdgePoint)
            edges.append(edge)
        }
        return edges
    }
}

/// 业务逻辑传入的节点Model需要实现此协议
protocol LayoutNodeProtocol {
    var nodeId: String { get }
    var contentWidth: CGFloat { get }
    var contentHeight: CGFloat { get }
    var marginLeft: CGFloat { get }
    var marginRight: CGFloat { get }
    var marginTop: CGFloat { get }
    var marginBottom: CGFloat { get }
    var downStream: [LayoutNodeProtocol] {get}
}
