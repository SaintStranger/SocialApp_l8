//
//  VKAuthorizationViewController.swift
//  SocialApp
//
//  Created by Антон Чечевичкин on 26.02.2021.
//

import UIKit
import WebKit


class VKAuthorizationViewController: UIViewController {
    
    //Почта programpervert@gmail.com
    //Пароль Pdt8JoKfkV7FEgY6nlpZ9tCx
    
    
    @IBOutlet weak var webView: WKWebView! {
        
        didSet {
            webView.navigationDelegate = self
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7774302"),
            URLQueryItem(name: "redirect_url", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: "270342"),
            URLQueryItem(name: "response_type", value: "token"),
//            URLQueryItem(name: "revoke", value: "1"),
            URLQueryItem(name: "v", value: "5.131"),
        ]

        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)

    }

}

extension VKAuthorizationViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        guard let url = navigationResponse.response.url, url.path == "/blank.html",
              let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
//        print("урл \(url) + фрагменты \(fragment)")

        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=")}
            .reduce([String:String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        let token = params["access_token"]
        
        let session = Session.instance
        
        session.token = token ?? "There is no token, Neo"

        print("Токен в синглтоне " + "\(session.token)" + "СТОП")
        

        decisionHandler(.cancel)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(identifier: "TabBarScreenViewController")
        present(vc, animated: true, completion: nil)

    }
}

