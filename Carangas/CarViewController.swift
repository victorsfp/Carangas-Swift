//
//  CarViewController.swift
//  Carangas
//
//  Created by Eric Brito on 21/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit
import WebKit
import Foundation

class CarViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbGasType: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    // MARK: - Properties
    var car: Car!

    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbBrand.text = car.brand
        lbGasType.text = car.gas
        lbPrice.text = "R$ \(car.price)"
        title = car.name
        
        let name = (title! + "+" + car.brand).replacingOccurrences(of: " ", with: "+")
        let urlString = "https://www.google.com.br/search?q=\(name)&tbm=isch"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        webView.allowsBackForwardNavigationGestures = true //HABILTA OS GESTURES
        webView.allowsLinkPreview = true //PRESSIONANDO O LINK CONSEGUIMOS VER O LINK TEMP
        webView .navigationDelegate = self
        webView.uiDelegate = self
        webView.load(request)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.car = car
    }
    

}


@available(iOS 13.0.0, *)
extension CarViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading.stopAnimating()
        webView.evaluateJavaScript("alert('é isso pessoal')") { returnObject, error in
            print(returnObject as Any)
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async {
        print(message)
    }
    
    
}
