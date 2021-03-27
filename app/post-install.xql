xquery version "3.0";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace sm="http://exist-db.org/xquery/securitymanager";

(: set rights for XQuery scripts :)
declare function local:update-rights($app-path){
    let $mode := "-rwxr-xr-x"
    return
    (
    sm:chmod(xs:anyURI(concat($app-path, "/controller.xql")), $mode),
    sm:chmod(xs:anyURI(concat($app-path, "/index.xq")), $mode),
    sm:chmod(xs:anyURI(concat($app-path, "/modules/app.xqm")), $mode),
    sm:chmod(xs:anyURI(concat($app-path, "/modules/data.xqm")), $mode),
    sm:chmod(xs:anyURI(concat($app-path, "/modules/overviews.xqm")), $mode)
    )
};

(: check if index collections exist :)
declare function local:check-index-collection($conf-path){
    let $conf-path-app := concat($conf-path, "/bibacme")
    let $conf-path-data := concat($conf-path-app, "/data")
    return
        if (not(xmldb:collection-available($conf-path-data)))
        then if (not(xmldb:collection-available($conf-path-app)))
            then (
                xmldb:create-collection($conf-path, "bibacme"),
                xmldb:create-collection($conf-path-app, "data")
                )
            else xmldb:create-collection($conf-path-app, "data")
        else ()
};

(: move index to system and reindex :)
declare function local:move-index($app-path, $conf-path){
	let $conf-path-data := concat($conf-path, "/bibacme/data")
	return
	   (
	   xmldb:copy-resource($app-path, "collection.xconf", $conf-path-data, "collection.xconf"),
	   xmldb:reindex(concat($app-path, "/data"))
	   )
};

let $app-path := "/db/apps/bibacme"
let $conf-path := "/db/system/config/db/apps"
return
(
(:local:update-rights($app-path), this does not work :)
local:check-index-collection($conf-path),
local:move-index($app-path, $conf-path)
)
