/-  *files
/+  dbug, default-agent
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 files=node]
+$  card  card:agent:gall
--
::
%-  agent:dbug
=|  state-0
=*  state  -
=<
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    hc    ~(. +> bowl)
++  on-init
  ^-  (quip card _this)
  :_  this
  [%pass /bind %arvo %e %connect `/files-upload %files]~
::
++  on-save  !>(state)
::
++  on-load
  |=  old-vase=vase
  ^-  (quip card _this)
  `this(state !<(state-0 old-vase))
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(our.bowl src.bowl)
  ?:  ?=(%handle-http-request mark)
    =/  req  !<  (pair @ta inbound-request:eyre)  vase
    ?.  =('POST' method.request.q.req)
      :_  this
      (response:hc p.req 405 ['Allow' 'POST']~ '405 Method not allowed')
    =/  =way  (decode-url:hc '/files-upload/' url.request.q.req)
    ?~  body.request.q.req
      :_  this
      (response:hc p.req 400 ~ '400 Bad Request: Body empty>')
    =/  =mite
      %-  parse-mime:hc
      %+  fall
        (get-header:http 'content-type' header-list.request.q.req)
      'application/octet-stream'
    =/  =mime  [mite u.body.request.q.req]
    =/  fil=file  [mime now.bowl]
    =/  fis=(unit node)  (~(put fi files) way ~ `fil)
    ?~  fis
      :_  this
      %:  response:hc
        p.req  422  ~
        '422 Unprocessable entity: Cannot add file at location'
      ==
    =/  per=?  (~(per fi u.fis) way)
    :_  this(files u.fis)
    :*  [%give %fact ~[/did] files-did+!>(`did`[%all u.fis])]
        (make-entry:hc way per mime)
        %:  response:hc
          p.req  201
          ['Location' (make-url:hc way)]~
          '201 Created: Success'
        ==
    ==
  ?.  ?=(%files-do mark)  (on-poke:def mark vase)
  =+  !<(=do vase)
  ?-    -.do
      %dir
    =.  files  (need (~(put fi files) way.do perm.do ~))
    :_  this
    [%give %fact ~[/did] files-did+!>(`did`[%all files])]~
  ::
      %del
    =/  ways  (~(key fi files) way.do)
    =/  cards=(list card)
      (turn ways delete-entry:hc)
    =.  files  (~(lop fi files) way.do)
    :_  this
    :_  cards
    [%give %fact ~[/did] files-did+!>(`did`[%all files])]
  ::
      %pub
    =.  files  (~(pro fi files) way.do perm.do)
    =/  ways  (~(key fi files) way.do)
    =/  cards=(list card)
      %+  turn  ways
      |=  =way
      ^-  card
      =/  =file  (~(got fi files) way)
      =/  per=?  (~(per fi files) way)
      (make-entry:hc way per mime.file)
    :_  this
    :_  cards
    [%give %fact ~[/did] files-did+!>(`did`[%all files])]
  ==
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card _this)
  ?.  ?=([%bind ~] wire)
    (on-arvo:def wire sign)
  ?.  ?=([%eyre %bound *] sign)
    (on-arvo:def wire sign)
  ~?  !accepted.sign
    %eyre-rejected-files-binding
  `this
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?>  =(src.bowl our.bowl)
  ?+    path  (on-watch:def path)
      [%http-response *]
    `this
  ::
      [%did ~]
    :_  this
    [%give %fact ~ files-did+!>(`did`[%all files])]~
  ==
::
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
::
|_  =bowl:gall
++  parse-mime
  |=  txt=@t
  |^  ^-  mite
  %-  fall
  :_  /application/octet-stream
  %+  rust  (cass (trip txt))
  ;~(plug part (ifix [fas (star next)] part) (easy ~))
  ++  part  (cook crip (star ;~(pose aln hep dot)))
  --
::
++  filename
  |=  =way
  ^-  tape
  (en-urlt:html (trip (rear way)))
::
++  make-url
  |=  =way
  ^-  @t
  %+  rap  3
  %+  join  '/'
  :-  '/files'
  %+  turn  way
  |=  =cord
  (crip (en-urlt:html (trip cord)))
::
++  decode-url
  |=  [prefix=@t url=@t]
  ^-  way
  %+  rash  url
  %+  cook
    |=  ents=(list tape)
    ^-  way
    %+  turn  ents
    |=  t=tape
    (crip (need (de-urlt:html t)))
  ;~(pfix (jest prefix) (more fas (star ;~(less fas next))))
::
++  path-to-way
  |=  =path
  ^-  way
  (turn path (cury slav %t))
::
++  way-to-path
|=  way=(list @t)
^-  path
(turn way (cury scot %t))
::
++  make-entry
  |=  [=way pub=? =mime]
  ^-  card
  =/  hed=header-list:http
    :~  ['Content-Type' (print-mime p.mime)]
        ['Content-Disposition' (crip "inline;filename=\"{(filename way)}\"")]
    ==
  =/  =cache-entry:eyre
    [!pub %payload [200 hed] `q.mime]
  [%pass (way-to-path way) %arvo %e %set-response (make-url way) `cache-entry]
::
++  delete-entry
  |=  =way
  ^-  card
  [%pass (way-to-path way) %arvo %e %set-response (make-url way) ~]
::
++  give-response
  |=  [id=@ta hed=response-header:http dat=(unit octs)]
  ^-  (list card)
  :~  [%give %fact ~[/http-response/[id]] %http-response-header !>(hed)]
      [%give %fact ~[/http-response/[id]] %http-response-data !>(dat)]
      [%give %kick ~[/http-response/[id]] ~]
  ==
::
++  response
  |=  [id=@ta code=@ud hed=header-list:http msg=@t]
  ^-  (list card)
  %^    give-response
      id
    :-  code
    :+  ['Content-Type' 'text/plain']
      ['Content-Length' (crip (a-co:co (met 3 msg)))]
    hed
  (some (as-octs:mimes:html msg))
--

