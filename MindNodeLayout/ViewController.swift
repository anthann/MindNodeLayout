//
//  ViewController.swift
//  MindNodeLayout
//
//  Created by anthann on 2019/10/10.
//  Copyright © 2019 anthann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var views: [String: UIView] = [:]
    private lazy var refreshButton = UIButton()
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var containerView: UIView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        scrollView.backgroundColor = .white
        scrollView.minimumZoomScale = 0.2
        scrollView.maximumZoomScale = 2.0
        scrollView.zoomScale = 0.3
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        refreshButton.setTitle("刷新", for: .normal)
        refreshButton.setTitleColor(UIColor.systemBlue, for: .normal)
        refreshButton.addTarget(self, action: #selector(onTapRefresh), for: .touchUpInside)
        view.addSubview(refreshButton)
        
        refresh()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = self.view.bounds
        refreshButton.frame = CGRect(x: 30, y: 30, width: 60, height: 44)
    }
    
    private func refresh() {
        NodeModel.numOfNodes = .random(in: 20...50)
        let tree = NodeModel()
        setupViews(root: tree)
        applyLayout(root: tree)
    }
    
    private func setupViews(root: NodeModel) {
        let view = UIView()
        view.backgroundColor = root.color
        containerView.addSubview(view)
        self.views[root.identifier] = view
        for child in root.children {
            setupViews(root: child)
        }
    }
    
    private func applyLayout(root: NodeModel) {
        let layout = Layout()
        layout.offset = CGPoint(x: 50, y: 50)
        layout.layout(root: root)
        guard let layoutTree = layout.layoutTree, let edges = layout.edges else {
            return
        }
        let contentSize = CGSize(width: layoutTree.treeWidth + 100, height: layoutTree.treeHeight + 100)
        scrollView.contentSize = contentSize
        containerView.frame = CGRect(origin: .zero, size: contentSize)
        applyFrame(node: layoutTree)
        drawEdges(edges)
    }
    
    private func applyFrame(node: LayoutNodeModel) {
        for child in node.children {
            applyFrame(node: child)
        }
        guard let view = views[node.identifier] else {
            return
        }
        view.frame = CGRect(x: node.x, y: node.y, width: node.width, height: node.height)
    }
    
    private func drawEdges(_ edges: [EdgeModel]) {
        for edge in edges {
            let path = UIBezierPath()
            path.lineWidth = 2
            path.move(to: edge.fromPoint)
            let controlPoint1 = CGPoint(x: edge.fromPoint.x + 0.5 * (edge.toPoint.x - edge.fromPoint.x), y: edge.fromPoint.y)
            let controlPoint2 = CGPoint(x: edge.fromPoint.x + 0.5 * (edge.toPoint.x - edge.fromPoint.x), y: edge.toPoint.y)
            path.addCurve(to: edge.toPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = UIColor.darkGray.cgColor
            layer.frame = containerView.bounds
            containerView.layer.addSublayer(layer)
        }
    }
    
    @objc func onTapRefresh(sender: UIButton) {
        views.removeAll()
        for view in containerView.subviews {
            view.removeFromSuperview()
        }
        for layer in containerView.layer.sublayers ?? [] {
            layer.removeFromSuperlayer()
        }
        refresh()
    }
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containerView
    }
}
