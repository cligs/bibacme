xquery version "3.0";

module namespace data="http://localhost/data";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace app="http://localhost/app" at "app.xqm";

(: ########## helper functions to fetch data ##########:)

declare function data:get-publication-countries($work-id as xs:string) as xs:string+{
    (: fetch publication countries of work editions :)
    let $edition-countries := data:get-work-editions($work-id)//tei:pubPlace/@corresp
    return distinct-values($edition-countries)
};



declare function data:get-work-editions($work-id as xs:string) as node()+{
    (: get the editions corresponding to a work :)
    (: $app:editions[some $id in tokenize(@corresp, "\s") satisfies $id = $work-id] :)
    let $regex := concat($work-id, "(\s|$)")
    let $editions := $app:editions[matches(@corresp, $regex)]
    return $editions
};


declare function data:get-first-edition($work-id as xs:string) as node()?{
    (: get first edition of a work :)
    let $editions := data:get-work-editions($work-id)
    let $year-first-ed := data:get-first-edition-year($work-id)
    let $first-editions := for $edition in $app:editions
                          let $date := ($edition//tei:date)[1]
                          let $year := data:get-edition-year($date)
                          where $year = $year-first-ed
                          return $edition
    return $first-editions[1]
};

declare function data:get-edition-year($date as node()) as xs:integer{
    (: get the year of an edition from its date :)
    if ($date/@when) 
    then xs:integer(substring($date/@when,1,4))
    else if ($date/@to)
    then xs:integer(substring($date/@to,1,4)) 
    else 0
};


declare function data:get-first-edition-year($work-id as xs:string) as xs:string{
    (: fetch the year of the first edition :)
    let $edition-dates := data:get-work-editions($work-id)//tei:date
    let $edition-years := for $date in $edition-dates
                           return data:get-edition-year($date)
    let $year-first-ed := xs:string(min($edition-years))
    return $year-first-ed
};


declare function data:get-decade-from-year($year as xs:integer) as xs:integer{
    let $decs := for $dec at $pos in $app:decades
                 return 
                    if ($pos gt 1)
                    then
                        if (number($app:decades[$pos - 1]) lt $year and $year le number($dec))
                        then number($dec) 
                        else 0
                    else 
                        if ($year le number($dec))
                        then number($dec)
                        else 0
    return max($decs)
};


declare function data:get-first-edition-decade($work-id as xs:string) as xs:string{
    (: fetch the decade of the first edition :)
    let $edition-dates := data:get-work-editions($work-id)//tei:date
    let $edition-years := for $date in $edition-dates
                           let $edition-year := data:get-edition-year($date)
                           return $edition-year
    let $year-first-ed := min($edition-years)
    let $dec-first-ed := xs:string(data:get-decade-from-year($year-first-ed))
    return $dec-first-ed 
};


declare function data:get-edition-decade($date as node()) as xs:string{
    (: get the decade of the edition :)
    let $year := data:get-edition-year($date)
    let $dec := xs:string(data:get-decade-from-year($year))
    return $dec
};


declare function data:get-first-edition-place($work-id as xs:string) as xs:string?{
    (: fetch the publication place of the first edition :)
    let $ed-first := data:get-first-edition($work-id)
    let $pub-place := $app:countries[@xml:id = ($ed-first//tei:pubPlace[1])/@corresp]/tei:placeName
    return $pub-place
};


declare function data:get-author-decades($author-id as xs:string) as xs:string+{
    (: fetch the decades of the first editions of the author's works :)
    let $author-work-ids := $app:works//range:field-eq("author-key", $author-id)/@xml:id
    let $decs := for $work-id in $author-work-ids
                 let $dec := data:get-first-edition-decade($work-id)
                 return $dec
    return $decs
};

declare function data:get-author-countries($author-id as xs:string) as xs:string+{
    (: fetch the publication countries of the editions of the author's works :)
    let $author-work-ids := $app:works//range:field-eq("author-key", $author-id)/@xml:id
    let $countries := for $work-id in $author-work-ids
                      let $country := data:get-publication-countries($work-id)
                      return $country
    return $countries
};

declare function data:get-nationalities() as xs:string+{
    for $nat in $app:authors//tei:nationality
    let $nat_val := $nat/text()
    group by $nat_val
    order by count($nat) descending
    return $nat_val
};

declare function data:get-nationality-numbers() as xs:integer+{
    for $nat in $app:authors//tei:nationality
    let $nat_val := $nat/text()
    group by $nat_val
    order by count($nat) descending
    return count($nat)
};

declare function data:get-sexes() as xs:string+{
    for $sex in $app:authors//tei:sex
    let $sex_val := $sex/text()
    group by $sex_val
    order by count($sex) descending
    return $sex_val
};

declare function data:get-sex-numbers() as xs:integer+{
    for $sex in $app:authors//tei:sex
    let $sex_val := $sex/text()
    group by $sex_val
    order by count($sex) descending
    return count($sex)
};

declare function data:get-work-numbers-by-nationality() as map(xs:string, xs:integer){
    (: fetch the number of works by the author's nationality :)
    map:merge(
        for $nat in distinct-values($app:authors//tei:nationality)
        let $author-ids := $app:authors[tei:nationality = $nat]/@xml:id
        let $count := count($app:works[tei:author/@key = $author-ids])
        return map:entry($nat, $count)
    )
};

declare function data:get-work-numbers-by-pubPlace-first() as map(xs:string, xs:integer) {
    (: fetch the number of works by the publication place (country) of the first edition :)
    let $work-map := map:merge(
                        for $work in $app:works
                        let $work-id := $work/@xml:id
                        let $editions := data:get-work-editions($work-id)
                        let $edition-dates := $editions//tei:date[1]
                        let $edition-years := for $date in $edition-dates
                                              return data:get-edition-year($date)
                        let $edition-years := if (count(index-of($edition-years, 0)) != count($edition-years))
                                              then
                                                  for $year in $edition-years
                                                  return if ($year != 0) then $year else()
                                              else 0
                        let $year-first-ed := min($edition-years)
                        let $year-first-ed := if ($year-first-ed) then $year-first-ed else 0
                        let $ed-first := ($editions[data:get-edition-year((.//tei:date)[1]) = $year-first-ed])[1]
                        let $ed-first-place := ($ed-first//tei:pubPlace)[1]/@corresp
                        let $place := $app:countries[@xml:id = $ed-first-place]/tei:placeName
                        return map:entry($work-id, $place)
    )
    let $place-map := map:merge(
                        let $values := for $key in map:keys($work-map)
                                       let $value := map:get($work-map, $key)
                                       return $value
                        for $val in distinct-values($values)
                        let $count := count(index-of($values, $val))
                        return map:entry($val, $count)
    )
    return $place-map
};


declare function data:get-author-name($author-key as xs:string+, $order as xs:string) as xs:string+{
    (: order: surname or forename :)
    let $authors := $app:authors/id($author-key)
    let $author-names := for $author in $authors
                        let $forename := ($author//tei:forename)[1]
                        let $surname := ($author//tei:surname)[1]
                        let $name := ($author//tei:name/text())[1]
                        return
                        if ($author//tei:surname)
                        then 
                            if ($order = "forename")
                            then string-join(($forename, $surname), " ")
                            else string-join(($surname, $forename), ", ")
                        else $name
    return $author-names
};


declare function data:get-first-letter($name as xs:string) as xs:string{
    let $str := translate($name,"¡¿","")
    let $two := upper-case(substring($str,1,2))
    return
        if ($two = ("CH", "LL"))
        then $two
        else substring($two,1,1)
};


declare function data:get-work-numbers-by-author() as map(xs:string, xs:integer){
    map:merge(
        for $author in $app:authors
        let $author-id := $author/@xml:id
        let $author-works := $app:works//range:field-eq("author-key", $author-id)
        let $work-num := count($author-works)
        return map:entry($author-id, $work-num)
    )
};


declare function data:get-XML($filename as xs:string) as node()+{
    let $doc := doc(concat($app:root,"/data/",$filename))
    let $stylesheet := doc(concat($app:root, "/stylesheets/copy-all-but-comments.xsl"))
    let $transform := transform:transform($doc, $stylesheet, ())
    return $transform
};


declare function data:get-author-nationality($author as node()) as xs:string{
    let $nat-val := $author/tei:nationality
    let $nat-term := $app:nationalities[tei:term[@type="general"] = $nat-val]
    let $sex := $author/tei:sex
    return
        if ($sex = "masculino")
        then $nat-term/tei:term[@type="male"]
        else if ($sex = "femenino")
        then $nat-term/tei:term[@type="female"]
        else $nat-term/tei:term[@type="general"]
};

