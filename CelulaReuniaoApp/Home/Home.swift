//
//  Home.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 30/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit

class Home: UIView {
    
 var view: UIView!
    
    @IBOutlet weak var txtNome: UILabel!
    @IBOutlet weak var txtBemVindo: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    
    func setupView() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: "Home", bundle: Bundle.main)
        let view = nib.instantiate(withOwner: self, options: nil) [0] as! UIView
        return view
    }
    func set(nome: String) {
        txtNome.text = nome
    }
    
    func set(bemvindo: String) {
        txtBemVindo.text = bemvindo
    }


}
