//
//  ViewController.m
//  LinkedInAPI
//
//  Created by Vaghula krishnan on 21/01/16.
//  Copyright © 2016 Vaghula krishnan. All rights reserved.
//

#import "ViewController.h"
#import "AppMacros.h"

const NSString *key=@"75oaw0qxknm8sn";
const NSString *secret=@"qEvpy3jnztKQonzg";
const NSString *authend=@"https://www.linkedin.com/uas/oauth2/authorization";
const NSString *acessend=@"https://www.linkedin.com/uas/oauth2/accessToken";
@interface ViewController ()
{
    UIButton *buttonGetStarted;
    UIButton *buttonprofile;
    UILabel *labelName;
    UILabel *labelProfile;
}

@end

@implementation ViewController

@synthesize webview;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.view.backgroundColor=[UIColor redColor];
    
   
    
  buttonGetStarted=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonGetStarted setFrame:CGRectMake(MarginLeft,MarginTop,self.view.bounds.size.width-(2*MarginLeft),Height)];
    [buttonGetStarted addTarget:self action:@selector(getStarted) forControlEvents:UIControlEventTouchUpInside];
     [buttonGetStarted setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonGetStarted setTitle:@"Authorize" forState:UIControlStateNormal];

     buttonGetStarted.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
     buttonGetStarted.backgroundColor=[UIColor blackColor];
    [buttonGetStarted setExclusiveTouch:YES];
    [[buttonGetStarted layer] setBorderWidth:1.4f];
    [[buttonGetStarted layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[buttonGetStarted layer] setCornerRadius:8.0f];
    [buttonGetStarted setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.view addSubview:buttonGetStarted];
    
    
    
    
    
     buttonprofile=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonprofile setFrame:CGRectMake(MarginLeft,buttonGetStarted.frame.origin.y+buttonGetStarted.frame.size.height+MarginDiff,self.view.bounds.size.width-(2*MarginLeft),Height)];
    [buttonprofile addTarget:self action:@selector(getprofile) forControlEvents:UIControlEventTouchUpInside];
    [buttonprofile setTitle:@"Fetch Details" forState:UIControlStateNormal];
    [buttonprofile setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonprofile.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
    buttonprofile.backgroundColor=[UIColor blackColor];
    [buttonprofile setExclusiveTouch:YES];
    [[buttonprofile layer] setBorderWidth:1.4f];
    [[buttonprofile layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[buttonprofile layer] setCornerRadius:8.0f];
    [buttonprofile setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    labelName=[[UILabel alloc] initWithFrame:CGRectMake(MarginLeft, buttonprofile.frame.origin.y+buttonprofile.frame.size.height+MarginDiff, self.view.bounds.size.width-(2*MarginLeft), Height)];
    labelName.textColor=[UIColor whiteColor];
    
    labelProfile=[[UILabel alloc] initWithFrame:CGRectMake(MarginLeft, labelName.frame.origin.y+labelName.frame.size.height+MarginDiff, self.view.bounds.size.width-(2*MarginLeft), Height)];
    labelProfile.textColor=[UIColor whiteColor];
    labelName.numberOfLines=3;
    [self.view addSubview:buttonGetStarted];
    [self.view addSubview:buttonprofile];
    [self.view addSubview:labelName];
    [self.view addSubview:labelProfile];
    
    [self checkUserDefaults];
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getprofile{
    NSString *accesstoke =[self getUserDefaults];
    NSString *targetURLString = @"https://api.linkedin.com/v1/people/~?format=json";

    
    // Initialize a mutable URL request object.
//    let request = NSMutableURLRequest(URL: NSURL(string: targetURLString)!)
//    
//    // Indicate that this is a GET request.
//    request.HTTPMethod = "GET"
//    
//    // Add the access token as an HTTP header field.
//    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//    
//    
//    // Initialize a NSURLSession object.
//    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
//    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:targetURLString]];
    request.HTTPMethod=@"Get";
    
    // Add the required HTTP header field.
    [request addValue:[NSString stringWithFormat:@"Bearer %@",accesstoke] forHTTPHeaderField:@"Authorization"];
    
    NSURLSession *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request
                                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                              
                                              if(!error){
                                              NSHTTPURLResponse *httpresp=(NSHTTPURLResponse *)response;
                                              if(httpresp.statusCode==200)
                                              {
                                                NSDictionary *dataDictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                             
                                                NSDictionary *profilelink = [dataDictionary objectForKey:@"siteStandardProfileRequest"];
                                                  
                                                  NSLog(@"profile link is %@",[profilelink objectForKey:@"url"]);
                                                
                                                  NSLog(@"profile link is %@",[dataDictionary objectForKey:@"firstName"]);
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                        labelProfile.text=[profilelink objectForKey:@"url"];
                                                      labelName.text=[NSString stringWithFormat:@"%@ %@",[dataDictionary objectForKey:@"firstName"],[dataDictionary objectForKey:@"lastName"]];

                                                  });

                                                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                  NSLog(@"TASK ::: %@",task);
                                                  
                                              }
                                              }
                                          }];
    
    [task resume];
    NSLog(@"Task Resume");
   
       [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    

}

-(void)getStarted
{
    
    NSString *responseType = @"code";

    
    // Set the redirect URL. Adding the percent escape characthers is necessary.
  //  let redirectURL = "https://com.appcoda.linkedin.oauth///oauth".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())!
    
    NSString *theOrigString=@"https://com.appcoda.linkedin.oauth/oauth";
    NSString *redirectURL=[theOrigString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];

    // Create a random string based on the time interval (it will be in the form linkedin12345679).
    NSString *state = @"linkedin12351236";
    
    // Set preferred scope.
    
    NSString *scope = @"r_basicprofile";
//    var authorizationURL = "\(authorizationEndPoint)?"
//    authorizationURL += "response_type=\(responseType)&"
//    authorizationURL += "client_id=\(linkedInKey)&"
//    authorizationURL += "redirect_uri=\(redirectURL)&"
//    authorizationURL += "state=\(state)&"
//    authorizationURL += "scope=\(scope)"
//    
//    print(authorizationURL)
    NSString *URL=[NSString stringWithFormat:@"%@?response_type=%@&client_id=%@&redirect_uri=%@&state=%@&scope=%@",authend,responseType,key,redirectURL,state,scope];
    NSLog(@"%@",URL);
    NSURLRequest *req=[NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:webview];
    webview.delegate = self;
     [webview loadRequest:req];
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSURL *url = request.URL;
    NSLog(@"%@",url);
    if([url.host isEqualToString:@"com.appcoda.linkedin.oauth"])
    {
        if([url.absoluteString containsString:@"code"]){
   //     if ([url.absoluteString.rangeOfString("code") != nil ]{
            // Extract the authorization code.
            NSArray *urlParts =[url.absoluteString componentsSeparatedByString:@"?"];
            
         //   let urlParts = url.absoluteString.componentsSeparatedByString("?")
            NSString *code =[urlParts[1] componentsSeparatedByString:@"="][1];
            //let code = urlParts[1].componentsSeparatedByString("=")[1]
            
            //requestForAccessToken(code)
            NSLog(@"\n code is %@",code);
            [self requestForAccessToken:code];
        }
    }
    return YES;
}


-(void)requestForAccessToken:(NSString *)authorizationCode{
    
    NSString *grantType = @"authorization_code";

    NSString *theOrigString=@"https://com.appcoda.linkedin.oauth/oauth";
    NSString *redirectURL=[theOrigString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];

//    var postParams = "grant_type=\(grantType)&"
//    postParams += "code=\(authorizationCode)&"
//    postParams += "redirect_uri=\(redirectURL)&"
//    postParams += "client_id=\(linkedInKey)&"
//    postParams += "client_secret=\(linkedInSecret)"
    
    NSString *URL=[NSString stringWithFormat:@"grant_type=%@&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@",grantType,authorizationCode,redirectURL,key,secret];
    
    NSData *postData=[URL dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:acessend]];
    request.HTTPMethod=@"POST";
    request.HTTPBody=postData;
    
    // Add the required HTTP header field.
    [request addValue:@"application/x-www-form-urlencoded;" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request
                                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                            if (!error) {
                                                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                if (httpResp.statusCode == 200) {
                                                    
                                                  //  let dataDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)

                                                    NSDictionary *dataDictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                    NSString *accesstoken =[dataDictionary objectForKey:@"access_token"];
                                                    
                                                    NSLog(@"acess token %@",accesstoken);
                                                    [self saveInUserDefaults:accesstoken];
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                    [webview removeFromSuperview];
                                                    });
                                                }
                                            }
                                          }];
    [task resume];
    
}
-(void)saveInUserDefaults:(NSString *)value{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setValue:value  forKey:@"Linkacesstoken"];
    [preferences synchronize];
    
}
-(NSString *)getUserDefaults{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    return [preferences objectForKey:@"Linkacesstoken"];
}

-(void)checkUserDefaults{
     NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if([preferences objectForKey:@"Linkacesstoken"]!=nil)
    {
        buttonGetStarted.enabled=NO;
        buttonprofile.enabled=YES;
    }
    else{
        buttonGetStarted.enabled=YES;
        buttonprofile.enabled=NO;
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // report the error inside the webview
    NSString* errorString = [NSString stringWithFormat:
                             @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                             error.localizedDescription];
    [webview loadHTMLString:errorString baseURL:nil];
}

@end
