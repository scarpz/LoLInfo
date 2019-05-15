//
//  LoadingView.swift
//  LoadingViewTest//
//  Created by Felipe Scarpitta on 29/04/2019.
//  Copyright © 2019 Felipe Scarpitta. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    // MARK: - Outlets
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var text: UILabel!
    
    private var isActive = false

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    // MARK: -  Private Methods
    private func setup() {
        Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    // MARK: - Public Methods
    func show() {
        self.resignFirstResponder()
        self.isActive = true
        guard let window = UIApplication.shared.windows.first else { return }
        window.addSubview(self)
    }
    
    func hide() {
        self.isActive = false
        self.removeFromSuperview()
    }
    
    func updateLoading(size: CGSize) {
        self.contentView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
