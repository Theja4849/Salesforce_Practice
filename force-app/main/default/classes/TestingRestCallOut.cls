public class TestingRestCallOut {
    public static void getUsersData(){
        HTTP httpObj= new HTTP();
            HTTPRequest req = new HTTPRequest();
        req.setEndpoint('https://dummyjson.com/users');
        req.setHeader('content-type','application/json');
        req.setMethod('GET');
        HTTPResponse res = new HTTPResponse();
            res= httpObj.send(req);
        system.debug('@@@@@res body'+res.getBody());       
    }
    public static void postUserLogin(){
        HTTP httpobj= new HTTP();
         HTTPRequest req = new HTTPRequest();
               req.setEndpoint('https://dummyjson.com/auth/login');
              req.setHeader('Content-Type', 'application/json');
               req.setMethod('POST');
               req.setBody(
        '{"username":"emilys",' +
        '"password":"emilyspass",' +
        '"expiresInMins":30}'
    );
           HTTPResponse res = new HTTPResponse();
             res = httpobj.send(req);
        system.debug('@@@@@@@@Login data'+res.getBody());
               
        
            
        
    }
}