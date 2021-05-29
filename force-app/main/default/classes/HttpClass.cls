public class HttpClass {

    //need to take off 'Enforce login IP ranges on every request' in Session settings
    public static Map<String,Object> uiAPIResponse(String recordTypesObject, Id recordTypeId, String token){
        //use the ui-api to get the picklist values for each record type
        String testURL = URL.getCurrentRequestUrl().toExternalForm();
        system.debug(testURL);
        String ENDPOINT_UIAPI = Url.getOrgDomainUrl().toExternalForm()+ '/services/data/v51.0/ui-api/object-info/'+recordTypesObject+'/picklist-values/'+recordTypeId;
        String METHOD_UIAPI = 'GET';
        Map<String, Object> untype = new Map<String,Object>();
        //create headers
        List<DataDictionaryObjects.HeaderObject> headerListUIAPI = new List<DataDictionaryObjects.HeaderObject>();
        DataDictionaryObjects.HeaderObject headerObjAuthUIAPI = new DataDictionaryObjects.HeaderObject();
        headerObjAuthUIAPI.key = 'Authorization';
        headerObjAuthUIAPI.value = 'Bearer '+token;
        headerListUIAPI.add(headerObjAuthUIAPI);
        DataDictionaryObjects.HeaderObject headerObjContent = new DataDictionaryObjects.HeaderObject();
        headerObjContent.key = 'Content-Type';
        headerObjContent.value = 'application/json';
        headerListUIAPI.add(headerObjContent);
        HttpResponse UIAPI_RESPONSE = callEndpoint(ENDPOINT_UIAPI, METHOD_UIAPI, headerListUIAPI);
        system.debug(UIAPI_RESPONSE.getBody());
        if(UIAPI_RESPONSE.getStatusCode() == 200){
        untype = (Map<String, Object>)JSON.deserializeUntyped(UIAPI_RESPONSE.getBody());
        }else{
            untype = null;
        }
        return untype;
    }

    public static HttpResponse callEndpoint(String endPoint, String method, List<DataDictionaryObjects.HeaderObject> headerObj) {
        List<DataDictionaryObjects.HeaderObject> headerList = new List<DataDictionaryObjects.HeaderObject>();
        headerList = headerObj;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod(method.toUpperCase());
        for(DataDictionaryObjects.HeaderObject headerItem : headerObj){
            request.setHeader(headerItem.key, headerItem.value);
        }

        HttpResponse response = http.send(request);
        return response;
    }
}