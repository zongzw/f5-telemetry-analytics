function post_handling(r) {
    r.subrequest('/dashboards/index.html', { method: 'GET' }, function(res) {
        if (res.status != 200) {
            r.return(res.status);
            return;
        }

        var resp = res.responseBody;
        while(resp.includes('__KIBANA_INTERNAL_PLACEHOLDER__')) {
            resp = resp.replace(
                "__KIBANA_INTERNAL_PLACEHOLDER__", 
                r.headersIn.host
            );
        }
        r.return(200, resp);
    });

    // FOR DEBUGING

    // var a, s, h;

    // s = "JS summary\n\n";

    // s += "Method: " + r.method + "\n";
    // s += "HTTP version: " + r.httpVersion + "\n";
    // s += "Host: " + r.headersIn.host + "\n";
    // s += "Remote Address: " + r.remoteAddress + "\n";
    // s += "URI: " + r.uri + "\n";

    // s += "Headers:\n";
    // for (h in r.headersIn) {
    //     s += "  header '" + h + "' is '" + r.headersIn[h] + "'\n";
    // }

    // s += "Args:\n";
    // for (a in r.args) {
    //     s += "  arg '" + a + "' is '" + r.args[a] + "'\n";
    // }

    // r.return(200, s);
    
}